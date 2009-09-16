;;;-*-Mode: LISP; Package: CCL -*-

;;	Change History (most recent first):
;;  5 10/3/96  slh  split out setf-runtime
;;  3 5/8/95   akh  fix defsetf which had block in wrong place, used var name as tag which totally confused eval
;;  2 2/2/95   akh  merge leibniz patches
;;  (do not edit before this line!!)

(in-package :ccl)

;; Copyright 1986-1989 Coral Software Corp.
;; Copyright 1989-1994 Apple Computer, Inc.
;; Copyright 1995 Digitool, Inc.

; Modification History
;
; get-setf-expansion-aux - fix for e.g. (incf (slot-value ... 'foo))
; -------- 5.2b5
; akh fix psetf for symbol-macro - didn't fix psetq though
; akh fix define-setf-method apply to pass test for (setf (apply ...))
; -------- 5.0b3
; 04/30/99 akh get-setf-expansion define-setf-expander (?) and special-operator-p  per ANSI CL
;; ------------- 4.3b1
;01/27/97 bill  (define-setf-method getf-test ...), remf-test
;-------------  4.0
;02/08/96 bill  ppc version of apply+. Revert (define-setf-method apply ...) to using it.
;12/18/95 bill  (defsetf %fixnum-ref %fixnum-set)
;10/23/95 slh   de-lapified: work around apply+
; 5/05/95 alice leibniz patches had defsetf block in wrong place with wrong tag, which in addition
;               to being wrong, totally confused eval.
;12/16/92 bill (psetf) no longer expands into (progn (setf nil nil))
;11/20/92 gb   defsetf: move BLOCK; psetf: don't use aux-function.
;07/30/92 bill shiftf calls its getters in the right order and uses
;              multiple-value-prog1 instead of multiple-value-list & values-list
;              rotatef also calls its getters in the right order.
;06/29/92 bill define-setf-method's for THE & GETF now pass the environment to get-setf-method.
;06/16/92 bill fix brain-damage in psetf
;              (setf (apply #'f ...) value) no longer conses
;------------  2.0
;02/21/92 gb   Use more GENSYMs in DEFSETF expansion.
;------ 2.0f2
;01/13/92 gb   Put declarations in the right place in DEFSETF.
;12/31/91 gb   really make &KEY more-or-less work in DEFSETF.
;12/10/91 gb   make &KEY more-or-less work in DEFSETF.
; 2.0b4
;09/27/91 gb   expand MACROLET-ed macros in GET-SETF-EXPANSION-AUX.
; 2.0b3
;08/23/91 alice Allow multiple store vars for shiftf, rotatef, assert. Rotatef return nil per Steele
;08/07/91 bill no more DEFSETF for DOCUMENTATION
;07/21/91 gb   Allow multiple store vars in DEFSETF; still seems to destrucure at the wrong time.
;              Careful about order of subform evaluation, I think.  DEFINE-MODIFY-MACRO special-cases
;              non-symbol-macro symbols.  PSETF, SETF handle multiple values; SHIFTF, ROTATEF, ASSERT
;              still need to.
;05/20/91 gb   Be a bit more aware of symbol macros; define-modify-macro creates code
;              which doesn't worry about repeated evaluation in non-symbol-macro-atom case.
;09/09/90 gb   use function-information to retrieve function information, punt if local macro.
;08/11/90 gz   In get-setf-method & default-setf-method, don't bind fixnum, so as
;              to allow inline structure refs in modify macros.
;07/23/90 akh  push and pushnew preserve evaluation order
;04/30/90 gb   no setf-method for char-bit.  Whew.
;12/31/89 gb   new macro-bind/parse-macro stuff.
;12/28/89 gz  Ignore local fns and default to #'(setf foo) in get-setf-method.
;              Don't bind *processing-setf*, since nobody looks at it.
;11/18/89 gz  setf methods in a hash table.
;             %structure-refs% hash table.
;11/02/89 bill added %pop
;03/25/89 gb no parse-defmacro or analyze1.
;03/03/89 gz Made (setf (get ...) ..) compile into put.
;            get-setf-method is here again.
;12/28/88 gz %structure-ref's may be non-fixnum.
;11/09/88 gb  &whole comes first in psetf definition.
;8/10/88 gz   setf-*.lisp -> setf.lisp.  Flushed pre-1.0 edit history.
; 5/19/88  jaj defined setf of the using define-setf-method
; 5/18/88   jaj unfixed incf and decf (fry's previous "fix" broke them.  the
;               problem was with THE)
;4/25/88 cfry added setf of nthcdr
; 1/6/88 cfry fixed defsetter and defsetf to work with the complex defsetf
;          form containing &key in the lambda-list.
; 10/07/87 cfry fixed incf and decf to work with args of the form (the ...)

(%include "ccl:Lib;setf-runtime.lisp")

(defun special-operator-p (symbol)  ;; belongs elsewhere
  (special-form-p symbol))


;;Bootstrapping.
(defvar %setf-methods% (let ((a (make-hash-table :test #'eq)))
                         (do-all-symbols (s)
                           (let ((f (get s 'bootstrapping-setf-method)))
                             (when f
                               (setf (gethash s a) f)
                               (remprop s 'bootstrapping-setf-method))))
                         a))
(defun %setf-method (name)
  (gethash name %setf-methods%))

(defun store-setf-method (name fn &optional doc)
  (puthash name %setf-methods% fn)
  (let ((type-and-refinfo (and #-bccl (boundp '%structure-refs%)
                               (gethash name %structure-refs%))))
    (typecase type-and-refinfo
      (fixnum
       (puthash name %structure-refs% (%ilogior2 (%ilsl $struct-r/o 1)
                                                 type-and-refinfo)))
      (cons
       (setf (%cdr type-and-refinfo) (%ilogior2 (%ilsl $struct-r/o 1)
                                                (%cdr type-and-refinfo))))
      (otherwise nil)))
  (set-documentation name 'setf doc) ;clears it if doc = nil.
  name)


;;; Note: The expansions for SETF and friends create needless LET-bindings of 
;;; argument values when using get-setf-method.
;;; That's why SETF no longer uses get-setf-method.  If you change anything
;;; here, be sure to make the corresponding change in SETF.

(defun get-setf-expansion (form &optional env)
  "Return five values needed by the SETF machinery: a list of temporary
   variables, a list of values with which to fill them, a list of temporaries
   for the new values, the setting function, and the accessing function."
  ;This isn't actually used by setf, but it has to be compatible.
  (get-setf-expansion-aux form env t))

(defun get-setf-method (form &optional environment)
  (get-setf-expansion-aux form environment nil))

(defun get-setf-method-multiple-value (form &optional environment)
  "Like Get-Setf-Method, but may return multiple new-value variables."
  (get-setf-expansion-aux form environment t))


(defun get-setf-expansion-aux (form environment multiple-store-vars-p)
  (let* ((temp nil) 
         (accessor nil))
    (if (atom form)
      (progn
        (unless (symbolp form) (signal-program-error $XNotSym form))
        (multiple-value-bind (symbol-macro-expansion expanded)
            (macroexpand-1 form environment)
          (if expanded
            (get-setf-expansion-aux symbol-macro-expansion environment
                                    multiple-store-vars-p)
            (let ((new-var (gensym)))
              (values nil nil (list new-var) `(setq ,form ,new-var) form)))))
      (multiple-value-bind (ftype local-p)
                           (function-information (setq accessor (car form)) environment)
        (if local-p
          (if (eq ftype :function)
            ;Local function or macro, so don't use global setf definitions.
            (default-setf-method form)
            (get-setf-expansion-aux (macroexpand-1 form environment) environment multiple-store-vars-p))
          (cond
           ((setq temp (gethash accessor %setf-methods%))
            (if (symbolp temp)
              (let ((new-var (gensym))
                    (args nil)
                    (vars nil)
                    (vals nil))
                (dolist (x (cdr form))
                    (let ((var (gensym)))
                      (push var vars)
                      (push var args)
                      (push x vals)))
                (setq args (nreverse args))
                (values (nreverse vars) 
                        (nreverse vals) 
                        (list new-var)
                        `(,temp ,@args ,new-var)
                        `(,accessor ,@args)))
              (multiple-value-bind (temps values storevars storeform accessform)
                                   (funcall temp form environment)
                (when (and (not multiple-store-vars-p) (not (= (length storevars) 1)))
                  (signal-program-error "Multiple store variables not expected in setf expansion of ~S" form))
                (values temps values storevars storeform accessform))))
           ((and (type-and-refinfo-p (setq temp (or (environment-structref-info accessor environment)
                                                    (and #-bccl (boundp '%structure-refs%)
                                                         (gethash accessor %structure-refs%)))))
                 (not (refinfo-r/o (if (consp temp) (%cdr temp) temp))))
            (if (consp temp)
              (let ((type (%car temp)))
                (multiple-value-bind
                  (temps values storevars storeform accessform)
                  (get-setf-method (defstruct-ref-transform (%cdr temp) (%cdr form)) environment)
                  (values temps values storevars
                          (let ((storevar (first storevars)))
                            `(the ,type
                                  (let ((,storevar (require-type ,storevar ',type)))
                                    ,storeform)))
                          `(the ,type ,accessform))))
              (get-setf-method (defstruct-ref-transform temp (%cdr form)) environment)))
	   (t
	    (multiple-value-bind (res win)
				 (macroexpand-1 form environment)
	      (if win
                (get-setf-expansion-aux res environment multiple-store-vars-p)
                (default-setf-method form))))))))))

(defun default-setf-method (form)
  (let ((new-value (gensym))
        (temp-vars ())
        (temp-args ())
        (temp-vals ()))
    (dolist (val (cdr form))
      (if (fixnump val)
        (push val temp-args)
        (let ((var (gensym)))
          (push var temp-vars)
          (push val temp-vals)
          (push var temp-args))))
    (setq temp-vars (nreverse temp-vars)
          temp-args (nreverse temp-args)
          temp-vals (nreverse temp-vals))
    (values temp-vars
	    temp-vals
	    (list new-value)
	    `(funcall #'(setf ,(car form)) ,new-value ,@temp-args)
	    `(,(car form) ,@temp-args))))

;;; The inverse for a generalized-variable reference function is stored in
;;; one of two ways:
;;;
;;; A SETF-INVERSE property corresponds to the short form of DEFSETF.  It is
;;; the name of a function takes the same args as the reference form, plus a
;;; new-value arg at the end.
;;;
;;; A SETF-METHOD-EXPANDER property is created by the long form of DEFSETF or
;;; by DEFINE-SETF-METHOD.  It is a function that is called on the reference
;;; form and that produces five values: a list of temporary variables, a list
;;; of value forms, a list of the single store-value form, a storing function,
;;; and an accessing function.

(eval-when (eval compile)
  (require 'defstruct-macros))
  
(defmacro set-get (symbol indicator value &optional (value1 () default-p))
  (if default-p
    `(put ,symbol ,indicator (progn ,value ,value1))
    `(put ,symbol ,indicator ,value)))

; (defsetf get set-get)
(store-setf-method 'get 'SET-GET)

; does this wrap a named block around the body yet ?
(defmacro define-setf-method (access-fn lambda-list &body body)
  `(define-setf-expander ,access-fn ,lambda-list ,@body))

; does this wrap a named block around the body yet ?
(defmacro define-setf-expander (access-fn lambda-list &body body)
  "Syntax like DEFMACRO, but creates a setf expander function. The body
  of the definition must be a form that returns five appropriate values."
  (unless (symbolp access-fn)
    (signal-program-error $xnotsym access-fn))
  (multiple-value-bind (lambda-form doc)
                       (parse-macro-1 access-fn lambda-list body)
    `(eval-when (load compile eval)
       (store-setf-method ',access-fn
                          (nfunction ,access-fn ,lambda-form)
                          ,@(when doc (list doc))))))

(defun rename-lambda-vars (lambda-list)
  (let* ((vars nil)
         (temps nil)
         (new-lambda nil)
         (state nil))
    (flet ((temp-symbol (s) (make-symbol (symbol-name s))))
      (declare (inline temp-symbol))
      (dolist (item lambda-list)
        (if (memq item lambda-list-keywords)
          (setq state item item (list 'quote item))
          (if (atom item)
            (progn
              (push item vars))
            (locally (declare (type cons item))
              (when (consp (cddr item))
                (push (caddr item) vars))
              (if (and (eq state '&key) (consp (car item)))
                (progn
                  (push (cadar item) vars)
                  (setq item `(list (list ,(list 'quote (caar item)) ,(cadar item)) ,@(cdr item))))
                (progn 
                  (push (car item) vars)
                  (setq item `(list ,(car item) ,@(cdr item))))))))
        (push item new-lambda))
      (setq temps (mapcar #'temp-symbol vars))
      (values `(list ,@(nreverse new-lambda)) (nreverse temps) (nreverse vars)))))

(defmacro defsetf (access-fn &rest rest &environment env)
  (unless (symbolp access-fn) (signal-program-error $xnotsym access-fn))
  (if (non-nil-symbol-p (%car rest))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (store-setf-method
        ',access-fn
        ',(%car rest)
        ,@(%cdr rest)))
    (destructuring-bind (lambda-list (store-var &rest mv-store-vars) &body body) rest
      (unless (verify-lambda-list lambda-list)
        (signal-program-error $XBadLambdaList lambda-list))
      (let* ((store-vars (cons store-var mv-store-vars)))
        (multiple-value-bind (lambda-list lambda-temps lambda-vars)
                             (rename-lambda-vars lambda-list)
          (multiple-value-bind (body decls doc)
                               (parse-body body env t)
            (setq body `((block ,access-fn ,@body)))
            (let* ((args (gensym))
                   (dummies (gensym))
                   (newval-vars (gensym))
                   (new-access-form (gensym))
                   (access-form (gensym))
                   (environment (gensym)))
              `(eval-when (:compile-toplevel :load-toplevel :execute)
                 (store-setf-method 
                  ',access-fn
                  #'(lambda (,access-form ,environment)
                      (declare (ignore ,environment))
                      (do* ((,args (cdr ,access-form) (cdr ,args))
                            (,dummies nil (cons (gensym) ,dummies))
                            (,newval-vars (mapcar #'(lambda (v) (declare (ignore v)) (gensym)) ',store-vars))
                            (,new-access-form nil))
                           ((atom ,args)
                            (setq ,new-access-form 
                                  (cons (car ,access-form) ,dummies))
                            (destructuring-bind ,(append lambda-vars store-vars )
                                                `,(append ',lambda-temps ,newval-vars)
                              ,@decls
                              (values
                               ,dummies
                               (cdr ,access-form)
                               ,newval-vars
                               `((lambda ,,lambda-list ,,@body)
                                 ,@,dummies)
                               ,new-access-form))))))
                 ,@(if doc (list doc))
                 ',access-fn))))))))
  
(defmacro define-modify-macro (name lambda-list function &optional doc-string)
  "Creates a new read-modify-write macro like PUSH or INCF."
  (let ((other-args nil)
        (rest-arg nil)
        (env (gensym))
        (reference (gensym)))
    
    ;; Parse out the variable names and rest arg from the lambda list.
    (do ((ll lambda-list (cdr ll))
         (arg nil))
        ((null ll))
      (setq arg (car ll))
      (cond ((eq arg '&optional))
            ((eq arg '&rest)
             (if (symbolp (cadr ll))
               (setq rest-arg (cadr ll))
               (error "Non-symbol &rest arg in definition of ~S." name))
             (if (null (cddr ll))
               (return nil)
               (error "Illegal stuff after &rest arg in Define-Modify-Macro.")))
            ((memq arg '(&key &allow-other-keys &aux))
             (error "~S not allowed in Define-Modify-Macro lambda list." arg))
            ((symbolp arg)
             (push arg other-args))
            ((and (listp arg) (symbolp (car arg)))
             (push (car arg) other-args))
            (t (error "Illegal stuff in lambda list of Define-Modify-Macro."))))
    (setq other-args (nreverse other-args))
      `(defmacro ,name (,reference ,@lambda-list &environment ,env)
         ,doc-string
         (if (symbolp (setq ,reference (%symbol-macroexpand ,reference ,env)))
           (list 'setq ,reference (list* ',function ,reference ,@other-args . ,(list rest-arg)))
            (multiple-value-bind (dummies vals newval setter getter)
                                (get-setf-method ,reference ,env)
             (do ((d dummies (cdr d))
                  (v vals (cdr v))
                  (let-list nil (cons (list (car d) (car v)) let-list)))
                 ((null d)
                  (push 
                   (list (car newval)
                         ,(if rest-arg
                            `(list* ',function getter ,@other-args ,rest-arg)
                            `(list ',function getter ,@other-args)))
                   let-list)
                  `(let* ,(nreverse let-list)
                     ,setter))))))))

(define-modify-macro incf (&optional (delta 1)) +
  "The first argument is some location holding a number.  This number is
  incremented by the second argument, DELTA, which defaults to 1.")

(define-modify-macro decf (&optional (delta 1)) -
  "The first argument is some location holding a number.  This number is
  decremented by the second argument, DELTA, which defaults to 1.")

  
(defmacro psetf (&whole call &rest pairs &environment env)  ;same structure as psetq
  (when pairs
    (if (evenp (length pairs))
      (let* ((places nil)
             (values nil)
             (tempsets nil)
             (the-progn (list 'progn))
             (place nil)
             (body the-progn)
             (valform nil))
        (loop
          (setq place (pop pairs) valform (pop pairs))
          (if (null pairs) (return))
          (push place places)
          (push valform values)
          (multiple-value-bind (temps vals newvals setter getter)
                               (get-setf-method-multiple-value place env)
            (push (list temps vals newvals setter getter) tempsets)))
        (dolist (temp tempsets)
          (destructuring-bind (temps vals newvals setter getter) temp
            (declare (ignore getter))
            (setq body
                  `(let
                     ,(let* ((let-list nil))
                        (dolist (x temps (nreverse let-list))
                          (push (list x (pop vals)) let-list)))
                     (multiple-value-bind ,newvals ,(pop values)
                       ,body)))
            (push setter (cdr the-progn))))
        (push `(setf ,place ,valform) (cdr the-progn))
        `(progn ,body nil))
      (error "Odd number of args in the call ~S" call))))

;;Simple Setf specializations



(defsetf cadr set-cadr)
(defsetf second set-cadr)


(defsetf cdar set-cdar)

(defsetf caar set-caar)

(defsetf cddr set-cddr)

(defsetf elt set-elt)
(defsetf aref aset)
(defsetf svref svset)
(defsetf char set-char)
(defsetf bit %bitset)

(defsetf schar set-schar)
(defsetf sbit %sbitset)
(defsetf symbol-value set)
(defsetf %schar %set-schar)


(defsetf symbol-plist set-symbol-plist)
(defsetf nth %setnth)

(defsetf nthcdr %set-nthcdr)

(defsetf fill-pointer set-fill-pointer)


(defsetf subseq (sequence start &optional (end nil)) (new-seq)
  `(progn (replace ,sequence ,new-seq :start1 ,start :end1 ,end)
	  ,new-seq))



(defsetf third set-caddr)
(defsetf fourth set-cadddr)
(defsetf fifth set-fifth)
(defsetf sixth set-sixth)
(defsetf seventh set-seventh)
(defsetf eighth set-eighth)
(defsetf ninth set-ninth)
(defsetf tenth set-tenth)


(defsetf caaar set-caaar)
(defsetf caadr set-caadr)
(defsetf cadar set-cadar)
(defsetf caddr set-caddr)
(defsetf cdaar set-cdaar)
(defsetf cdadr set-cdadr)
(defsetf cddar set-cddar)
(defsetf cdddr set-cdddr)




(defsetf caaaar set-caaaar)
(defsetf caaadr set-caaadr)
(defsetf caadar set-caadar)
(defsetf caaddr set-caaddr)
(defsetf cadaar set-cadaar)
(defsetf cadadr set-cadadr)
(defsetf caddar set-caddar)
(defsetf cadddr set-cadddr)


(defsetf cdaaar set-cdaaar)
(defsetf cdaadr set-cdaadr)
(defsetf cdadar set-cdadar)
(defsetf cdaddr set-cdaddr)
(defsetf cddaar set-cddaar)
(defsetf cddadr set-cddadr)
(defsetf cdddar set-cdddar)
(defsetf cddddr set-cddddr)

(defsetf %fixnum-ref %fixnum-set)

(define-setf-method the (typespec expr &environment env)
  (multiple-value-bind (dummies vals newval setter getter)
                       (get-setf-method expr env)
    (let ((store-var (gensym)))
      (values
       dummies
       vals
       (list store-var)
       `(let ((,(car newval) ,store-var))
                         ,setter)
       `(the ,typespec ,getter)))))

   
(define-setf-method apply (function &rest args &environment env)
  (if (and (listp function)
	   (= (list-length function) 2)
	   (eq (first function) 'function)
	   (symbolp (second function)))
      (setq function (second function))
      (error
       "Setf of Apply is only defined for function args of form #'symbol."))
  (multiple-value-bind (dummies vals newval setter getter)
		       (get-setf-expansion (cons function args) env)
    ;; Make sure the place is one that we can handle.
    ;;Mainly to insure against cases of ldb and mask-field and such creeping in.
    (cond ((and (eq (car (last args)) (car (last vals)))
                (eq (car (last getter)) (car (last dummies)))
                newval
                (null (cdr newval))
                (eq (car (last setter)) (car newval))
                (eq (car (last setter 2)) (car (last dummies))))
           ; (setf (foo ... argn) bar) -> (set-foo ... argn bar)
           (values dummies vals newval
                   `(apply+ (function ,(car setter))
                            ,@(butlast dummies)
                            ,@(last dummies)
                            ,(car newval))
	           `(apply (function ,(car getter)) ,@(cdr getter))))
          ((and (eq (car (last args)) (car (last vals)))
                (eq (car (last getter)) (car (last dummies)))
                newval
                (null (cdr newval))
                (eq (car setter) 'funcall)
                (eq (third setter) (car newval))
                (eq (car (last setter)) (car (last dummies))))
           ; (setf (foo ... argn) bar) -> (funcall #'(setf foo) bar ... argn)  [with bindings for evaluation order]
           (values dummies vals newval
                   `(apply ,@(cdr setter))
                   `(apply (function ,(car getter)) ,@(cdr getter))))
          (t (error "Apply of ~S is not understood as a location for Setf."
		    function)))))

;;These are the supporting functions for the am-style hard-cases of setf.
(defun assoc-2-lists (list1 list2)
  "Not CL. Returns an assoc-like list with members taken by associating corresponding
   elements of each list. uses list instead of cons.
   Will stop when first list runs out."
  (do* ((lst1 list1 (cdr lst1))
        (lst2 list2 (cdr lst2))
        (result nil))
       ((null lst1) result)
       (setq result (cons (list (car lst1)
                                (car lst2))
                          result))))

(defun make-gsym-list (size)
  "Not CL. Returns a list with size members, each being a different gensym"
  (let ((temp nil))
        (dotimes (arg size temp)
          (declare (fixnum arg))
          (setq temp (cons (gensym) temp)))))
;;;;;;;

(define-setf-method getf (plist prop &optional (default () default-p)
                                     &aux (prop-p (not (quoted-form-p prop)))
                                     &environment env)
 (multiple-value-bind (vars vals stores store-form access-form)
                      (get-setf-method plist env)
   (when default-p (setq default (list default)))
   (let ((prop-var (if prop-p (gensym) prop))
         (store-var (gensym))
         (default-var (if default-p (list (gensym)))))
     (values
      `(,@vars ,.(if prop-p (list prop-var)) ,@default-var)
      `(,@vals ,.(if prop-p (list prop)) ,@default)
      (list store-var)
      `(let* ((,(car stores) (setprop ,access-form ,prop-var ,store-var)))
         ,store-form
         ,store-var)
      `(getf ,access-form ,prop-var ,@default-var)))))

(define-setf-method getf-test (plist prop test &optional (default () default-p)
                                       &aux (prop-p (not (quoted-form-p prop)))
                                       &environment env)
 (multiple-value-bind (vars vals stores store-form access-form)
                      (get-setf-method plist env)
   (when default-p (setq default (list default)))
   (let ((prop-var (if prop-p (gensym) prop))
         (test-var (gensym))
         (store-var (gensym))
         (default-var (if default-p (list (gensym)))))
     (values
      `(,@vars ,.(if prop-p (list prop-var)) ,test-var ,@default-var)
      `(,@vals ,.(if prop-p (list prop)) ,test ,@default)
      (list store-var)
      `(let* ((,(car stores) (setprop-test ,access-form ,prop-var ,test-var ,store-var)))
         ,store-form
         ,store-var)
      `(getf-test ,access-form ,prop-var ,test-var ,@default-var)))))

(define-setf-method ldb (bytespec place &environment env)
  (multiple-value-bind (dummies vals newval setter getter)
		       (get-setf-method place env)
    (let ((btemp (gensym))
	  (gnuval (gensym)))
      (values (cons btemp dummies)
	      (cons bytespec vals)
	      (list gnuval)
	      `(let ((,(car newval) (dpb ,gnuval ,btemp ,getter)))
		 ,setter
		 ,gnuval)
	      `(ldb ,btemp ,getter)))))


(define-setf-method mask-field (bytespec place &environment env)
  (multiple-value-bind (dummies vals newval setter getter)
		       (get-setf-method place env)
    (let ((btemp (gensym))
	  (gnuval (gensym)))
      (values (cons btemp dummies)
	      (cons bytespec vals)
	      (list gnuval)
	      `(let ((,(car newval) (deposit-field ,gnuval ,btemp ,getter)))
		 ,setter
		 ,gnuval)
	      `(mask-field ,btemp ,getter)))))

(defmacro shiftf (arg1 arg2 &rest places-&-nuval &environment env)
  (setq places-&-nuval (list* arg1 arg2 places-&-nuval))
  (let* ((nuval (car (last places-&-nuval)))
         (places (cdr (reverse places-&-nuval)))  ; not nreverse, since &rest arg shares structure with &whole.
         (setters (list 'progn))
         (last-getter nuval)
         last-let-list
         let-list
         (body setters))
    (dolist (place places)
      (multiple-value-bind (vars values storevars setter getter)
                           (get-setf-method-multiple-value place env)
        (dolist (v vars)
          (push (list v (pop values)) let-list))
        (push setter (cdr setters))
        (setq body
              (if last-let-list
                `(let* ,(nreverse last-let-list)
                   (multiple-value-bind ,storevars ,last-getter
                     ,body))
                `(multiple-value-bind ,storevars ,last-getter
                   ,body))
              last-let-list let-list
              let-list nil
              last-getter getter)))
    (if last-let-list
      `(let* ,(nreverse last-let-list)
         (multiple-value-prog1 ,last-getter
           ,body))
      `(multiple-value-prog1 ,last-getter
         ,body))))

;(shiftf (car x)(cadr x) 3)

#|
(defmacro rotatef (&rest args &environment env)
  (let* ((setf-result nil)
         (let-result nil)
         (last-store nil)
         (fixpair nil))
    (dolist (arg args)
      (multiple-value-bind (vars vals storevars setter getter) 
                           (get-setf-method arg env)
        (dolist (var vars)
          (push (list var (pop vals)) let-result))
        (push (list last-store getter) let-result)
        (unless fixpair (setq fixpair (car let-result)))
        (push setter setf-result)
        (setq last-store (car storevars))))
    (rplaca fixpair last-store)
    `(let* ,(nreverse let-result) ,@(nreverse setf-result) nil)))


;(rotatef (blob x)(blob y))
(defun blob (x) (values (car x)(cadr x)))
(define-setf-method blob (x)
    (let ((v1 (gensym))(v2 (gensym))(v3 (gensym)))
    (values
     (list v1)
     (list x)
     (list v2 v3)      
     `(progn (setf (car ,v1) ,v2)
             (setf (cadr ,v1) ,v3))     
     `(values (car ,v1)(cadr ,v1)))))
|#

(defmacro rotatef (&rest args &environment env)
  (when args
    (let* ((places (reverse args))  ; not nreverse, since &rest arg shares structure with &whole.
           (final-place (pop places))
           (setters (list 'progn nil))
           last-let-list
           let-list
           (body setters))
      (multiple-value-bind (final-vars final-values final-storevars
                                       final-setter last-getter)
                           (get-setf-method-multiple-value final-place env)
        (dolist (v final-vars)
          (push (list v (pop final-values)) last-let-list))
        (push final-setter (cdr setters))
        (dolist (place places)
          (multiple-value-bind (vars values storevars setter getter)
                               (get-setf-method-multiple-value place env)
            (dolist (v vars)
              (push (list v (pop values)) let-list))
            (push setter (cdr setters))
            (setq body
                  (if last-let-list
                    `(let* ,(nreverse last-let-list)
                       (multiple-value-bind ,storevars ,last-getter
                         ,body))
                    `(multiple-value-bind ,storevars ,last-getter
                       ,body))
                  last-let-list let-list
                  let-list nil
                  last-getter getter)))
        (if last-let-list
          `(let* ,(nreverse last-let-list)
             (multiple-value-bind ,final-storevars ,last-getter
               ,body))
          `(multiple-value-bind ,final-storevars ,last-getter
             ,body))))))



(defmacro push (value place &environment env)
  (if (not (consp place))
    `(setq ,place (cons ,value ,place))
    (multiple-value-bind (dummies vals store-var setter getter)
                         (get-setf-method place env)
      (let ((valvar (gensym)))
        `(let* ((,valvar ,value)
                ,@(mapcar #'list dummies vals)
                (,(car store-var) (cons ,valvar ,getter)))
           ,@dummies
           ,(car store-var)
           ,setter)))))

(defmacro pushnew (value place &rest keys &environment env)                               
  (if (not (consp place))
    `(setq ,place (adjoin ,value ,place ,@keys))
    (let ((valvar (gensym)))
      (multiple-value-bind (dummies vals store-var setter getter)
                           (get-setf-method place env)
        `(let* ((,valvar ,value)
                ,@(mapcar #'list dummies vals)
                (,(car store-var) (adjoin ,valvar ,getter ,@keys)))
           ,@dummies
           ,(car store-var)
           ,setter)))))

(defmacro pop (place &environment env &aux win)
  (while (atom place)
    (multiple-value-setq (place win) (macroexpand-1 place env))
    (unless win
      (return-from pop
        `(prog1 (car ,place) (setq ,place (cdr (the list ,place)))))))
  (let ((value (gensym)))
    (multiple-value-bind (dummies vals store-var setter getter)
                         (get-setf-method place env)
      `(let* (,@(mapcar #'list dummies vals)
              (,value ,getter)
              (,(car store-var) (cdr ,value)))
         ,@dummies
         ,(car store-var)
         (prog1
           (%car ,value)
           ,setter)))))

(defmacro %pop (symbol)
  `(prog1 (%car ,symbol) (setq ,symbol (%cdr ,symbol))))

#|
(defmacro push (item place)
  (if (not (consp place))
    `(setq ,place (cons ,item ,place))
    (let* ((arg-num (1- (length place)))
           (place-args (make-gsym-list arg-num)))
      `(let ,(cons (list 'nu-item item)
                   (reverse (assoc-2-lists place-args (cdr place))))
         (setf (,(car place) ,@place-args)
               (cons nu-item (,(car place) ,@place-args)))))))

(defmacro pushnew (item place &rest key-args)
  (let ((item-gsym (gensym)))
    (if (not (consp place))
      `(let ((,item-gsym ,item))
         (setq ,place (adjoin ,item-gsym ,place ,@key-args)))
      (let* ((arg-num (1- (length place)))
             (place-args (make-gsym-list arg-num)))
        `(let ,(cons (list item-gsym item)
                     (reverse (assoc-2-lists place-args (cdr place))))
           (setf (,(car place) ,@place-args)
                 (adjoin ,item-gsym (,(car place) ,@place-args)
                         ,@key-args)))))))
(defmacro pop (place)
  (if (not (consp place))               ;  screw: symbol macros.
    `(prog1 (car ,place) (setq ,place (%cdr ,place)))
    (let* ((arg-num (1- (length place)))
           (place-args (make-gsym-list arg-num)))
      `(let ,(reverse (assoc-2-lists place-args (cdr place)))
         (prog1 (car (,(car place) ,@place-args))
           (setf (,(car place) ,@place-args)
                 (cdr (,(car place) ,@place-args))))))))
|#

(defmacro remf (place indicator &environment env)
  "Place may be any place expression acceptable to SETF, and is expected
  to hold a property list or ().  This list is destructively altered to
  remove the property specified by the indicator.  Returns T if such a
  property was present, NIL if not."
  (multiple-value-bind (dummies vals newval setter getter)
                       (get-setf-method place env)
    (do* ((d dummies (cdr d))
          (v vals (cdr v))
          (let-list nil)
          (ind-temp (gensym))
          (local1 (gensym))
          (local2 (gensym)))
         ((null d)
          (push (list ind-temp indicator) let-list)
          (push (list (car newval) getter) let-list)
          `(let* ,(nreverse let-list)
             (do ((,local1 ,(car newval) (cddr ,local1))
                  (,local2 nil ,local1))
                 ((atom ,local1) nil)
               (cond ((atom (cdr ,local1))
                      (error "Odd-length property list in REMF."))
                     ((eq (car ,local1) ,ind-temp)
                      (cond (,local2
                             (rplacd (cdr ,local2) (cddr ,local1))
                             (return t))
                            (t (setq ,(car newval) (cddr ,(car newval)))
                               ,setter
                               (return t))))))))
      (push (list (car d) (car v)) let-list))))

(defmacro remf-test (place indicator test &environment env)
  "Place may be any place expression acceptable to SETF, and is expected
  to hold a property list or ().  This list is destructively altered to
  remove the property specified by the indicator.  Returns T if such a
  property was present, NIL if not."
  (multiple-value-bind (dummies vals newval setter getter)
                       (get-setf-method place env)
    (do* ((d dummies (cdr d))
          (v vals (cdr v))
          (let-list nil)
          (ind-temp (gensym))
          (test-temp (gensym))
          (local1 (gensym))
          (local2 (gensym)))
         ((null d)
          (push (list (car newval) getter) let-list)
          (push (list ind-temp indicator) let-list)
          (push (list test-temp test) let-list)
          `(let* ,(nreverse let-list)
             (do ((,local1 ,(car newval) (cddr ,local1))
                  (,local2 nil ,local1))
                 ((atom ,local1) nil)
               (cond ((atom (cdr ,local1))
                      (error "Odd-length property list in REMF."))
                     ((funcall ,test-temp (car ,local1) ,ind-temp)
                      (cond (,local2
                             (rplacd (cdr ,local2) (cddr ,local1))
                             (return t))
                            (t (setq ,(car newval) (cddr ,(car newval)))
                               ,setter
                               (return t))))))))
      (push (list (car d) (car v)) let-list))))

(define-setf-expander values (&rest places &environment env) 
  (let* ((setters ())
	 (getters ())
	 (all-dummies ()) 
	 (all-vals ()) 
	 (newvals ())) 
    (dolist (place places) 
      (multiple-value-bind (dummies vals newval setter getter) 
	  (get-setf-expansion place env) 
	(setf all-dummies (append all-dummies dummies)) 
	(setf all-vals (append all-vals vals)) 
	(setf newvals (append newvals newval)) 
	(push setter setters)
	(push getter getters))) 
      (values all-dummies all-vals newvals 
              `(values ,@(nreverse setters)) `(values ,@(nreverse getters)))))
