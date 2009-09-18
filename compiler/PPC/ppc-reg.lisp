;;;-*- Mode: Lisp; Package: (PPC :use CL) -*-

;; $Log: ppc-reg.lisp,v $
;; Revision 1.2  2002/11/18 05:36:30  gtbyers
;; Add CVS log marker
;;
;;	Change History (most recent first):
;;  5 6/7/96   akh  probably no change
;;  4 5/23/96  akh  define hard-reg-class-fpr-type-double and single
;;  2 10/6/95  gb   Type bits for node-gprs.
;;  (do not edit before this line!!)

;;; 03/01/97 gb   lregs as well as "hard" regs.
;;; -------- 4.0
;;; 01/16/96 gb   make-hard-fp-reg.

(in-package "PPC")

; A "register spec" is a fixnum.  Bit 28 is clear; bits 24-26 (inclusive) define the
; type of register-spec in question.
; Of course, a register spec can also be a "logical register" (lreg) structure.
; Someday soon, these might totally replace the fixnum "hard regspecs" that're
; described in this file, and might be used to refer to stack-based values as
; well as registers.  In the meantime, we have to bootstrap a bit.
(defmacro register-spec-p (regspec)
  `(%register-spec-p ,regspec))

(defun %register-spec-p (regspec)
  (if (typep regspec 'fixnum)
    (not (logbitp 28 (the fixnum regspec)))
    (typep regspec 'ccl::lreg)))

(defconstant regspec-type-byte (byte 3 24))
(defmacro regspec-type (regspec)
  `(%regspec-type ,regspec))

(defun %regspec-type (regspec)
  (if (typep regspec 'fixnum)
    (the fixnum (ldb regspec-type-byte (the fixnum regspec)))
    (if (typep regspec 'ccl::lreg)
      (the fixnum (ccl::lreg-type regspec))
      (error "bad regspec: ~s" regspec))))

;;; Physical registers.
;;; A regspec-type of 0 denotes some type of "physical" (machine) register:
;;; a GPR, FPR, CR field, CR bit, or SPR.
(defconstant regspec-hard-reg-type 0)
; There are at most 32 members of any class of hard reg, so bytes 5-8 are
; used to encode that information; the "value" of the hard reg in question
; is in bits 0-4.
; In some cases, we can also attach a "mode" to a hard-reg-spec.
; Usually, non-0 values of the "mode" field are attached to the
; "imm" (unboxed) registers.
; A GPR whose "mode" is hard-reg-class-gpr-mode-node can have a "type"
; field which asserts that the register's contents map onto one or more
; of the primitive non-node types.  This information can help some of 
; the functions that copy between GPRs of different "mode" elide some
; type-checking.
(defconstant regspec-hard-reg-type-class-byte (byte 3 5))
(defconstant regspec-hard-reg-type-value-byte (byte 5 0))
(defconstant regspec-hard-reg-type-mode-byte (byte 4 8))
(defconstant regspec-hard-reg-type-type-byte (byte 8 12))

(defconstant hard-reg-class-gpr 0)
(defconstant hard-reg-class-fpr 1)
(defconstant hard-reg-class-crf 2)      ; Value is one of 0, 4, 8, ... 28
(defconstant hard-reg-class-crbit 3)
(defconstant hard-reg-class-spr 4)

; "mode" values for GPRs.
(defconstant hard-reg-class-gpr-mode-node 0)    ; a tagged lisp object
(defconstant hard-reg-class-gpr-mode-u32 1)     ; unboxed unsigned 32-bit value
(defconstant hard-reg-class-gpr-mode-s32 2)     ; unboxed signed 32-bit value
(defconstant hard-reg-class-gpr-mode-u16 3)     ; unboxed unsigned 16-bit value
(defconstant hard-reg-class-gpr-mode-s16 4)     ; unboxed signed 16-bit value
(defconstant hard-reg-class-gpr-mode-u8 5)      ; unboxed unsigned 8-bit value
(defconstant hard-reg-class-gpr-mode-s8 6)      ; unboxed signed 8-bit value
(defconstant hard-reg-class-gpr-mode-address 7) ; unboxed unsigned 32-bit address

; "mode" values for FPRs. 
(defconstant hard-reg-class-fpr-mode-double 0)          ; unboxed IEEE double
(defconstant hard-reg-class-fpr-mode-single 1)          ; unboxed IEEE single

; "type" values for FPRs - type of SOURCE may be encoded herein
(defconstant hard-reg-class-fpr-type-double 0)          ;  IEEE double
(defconstant hard-reg-class-fpr-type-single 1)          ; IEEE single


(defmacro set-regspec-mode (regspec mode)
  `(%set-regspec-mode ,regspec ,mode))

(defun %set-regspec-mode (regspec mode)
  (if (typep regspec 'fixnum)
    (dpb (the fixnum mode) regspec-hard-reg-type-mode-byte regspec)
    (if (typep regspec 'ccl::lreg)
      (progn (setf (ccl::lreg-mode regspec) mode) regspec)
      (error "bad regspec: ~s" regspec))))

(defmacro get-regspec-mode (regspec)
  `(%get-regspec-mode ,regspec))

(defun %get-regspec-mode (regspec)
  (if (typep regspec 'fixnum)
    (ldb regspec-hard-reg-type-mode-byte regspec)
    (if (typep regspec 'ccl::lreg)
      (ccl::lreg-mode regspec)
      (error "bad regspec: ~s" regspec))))


(defmacro node-regspec-type-modes (modes)
  `(the fixnum (logior ,@(mapcar #'(lambda (x) `(ash 1 ,x)) modes))))

(defmacro set-node-regspec-type-modes (regspec &rest modes)
  `(%set-node-regspec-type-modes ,regspec (node-regspec-type-modes ,modes)))

(defun %set-node-regspec-type-modes (regspec modes)
  (if (typep regspec 'fixnum)
    (dpb (the fixnum modes) regspec-hard-reg-type-type-byte (the fixnum regspec))
    (if (typep regspec 'ccl::lreg)
      (progn (setf (ccl::lreg-type regspec) modes) regspec)
      (error "bad regspec: ~s" regspec))))

(defmacro get-node-regspec-type-modes (regspec)
  `(%get-regspec-type-modes ,regspec))

(defun %get-regspec-type-modes (regspec)
  (if (typep regspec 'fixnum)
    (ldb regspec-hard-reg-type-type-byte (the fixnum regspec))
    (if (typep regspec 'ccl::lreg)
      (ccl::lreg-type regspec)
      (error "bad regspec: ~s" regspec))))

(defmacro hard-reg-class-mask (&rest classes)
  `(the fixnum (logior ,@(mapcar #'(lambda (x) `(ash 1 ,x)) classes))))

(defconstant hard-reg-class-gpr-mask (hard-reg-class-mask hard-reg-class-gpr))
(defconstant hard-reg-class-gpr-crf-mask (hard-reg-class-mask hard-reg-class-gpr hard-reg-class-crf))

; Assuming that "regspec" denotes a physical register, return its class.
(defmacro hard-regspec-class (regspec)
  `(%hard-regspec-class ,regspec))

(defun %hard-regspec-class (regspec)
  (if (typep regspec 'fixnum)
    (the fixnum (ldb regspec-hard-reg-type-class-byte (the fixnum regspec)))
    (if (typep regspec 'ccl::lreg)
      (ccl::lreg-class regspec)
      (error "bad regspec: ~s" regspec))))

; Return physical regspec's value:
(defmacro hard-regspec-value (regspec)
  `(%hard-regspec-value ,regspec))

(defun %hard-regspec-value (regspec)
  (if (typep regspec 'fixnum)
    (the fixnum (ldb regspec-hard-reg-type-value-byte (the fixnum regspec)))
    (if (typep regspec 'ccl::lreg)
      (ccl::lreg-value regspec)
      (error "bad regspec: ~s" regspec))))

;;; Logical (as opposed to "physical") registers are represented by structures
;;; of type CCL::LREG.  The structures let us track information about assignments
;;; and references to lregs, and the indirection lets us defer decisions about
;;; storage mapping (register assignment, etc.) until later.

;; A GPR which is allowed to hold any lisp object (but NOT an object header.)
(defconstant regspec-lisp-reg-type 1)

;; A GPR which is allowed to contain any -non- lisp object.
(defconstant regspec-unboxed-reg-type 2)

;; A GPR which can contain either an immediate lisp object (fixnum, immediate)
;; or any non-lisp object.
(defconstant regspec-any-gpr-reg-type (logior regspec-lisp-reg-type regspec-unboxed-reg-type))

;; An FPR.  All FPRs are created equal; there's no reason to 
;; worry about whether an FPR's holding a 32 or 64-bit float.
(defconstant regspec-fpr-reg-type 4)

;; One of the 8 fields of the Condition Register.
(defconstant regspec-crf-reg-type 5)

;; One of the 32 bits of the Condition Register.
(defconstant regspec-crbit-reg-type 6)

(defmacro make-hard-crf-reg (crf)
  `(dpb hard-reg-class-crf regspec-hard-reg-type-class-byte (the fixnum ,crf)))
  
(defmacro make-hard-fp-reg (regnum &optional (mode #.hard-reg-class-fpr-mode-double))
  `(dpb (the fixnum ,mode) 
        #.regspec-hard-reg-type-mode-byte 
        (dpb #.hard-reg-class-fpr #.regspec-hard-reg-type-class-byte (the fixnum ,regnum))))
  
;;; "Memory specs" have bit 28 set.  Since bit 28 is the sign bit in 68K MCL,
;;; we have to be a little careful when creating them to ensure that the result
;;; is a fixnum.

(defmacro memory-spec-p (thing)
  `(if (typep ,thing 'fixnum) (logbitp 28 (the fixnum ,thing))))

(defmacro make-memory-spec (thing)
  `(logior (ash -1 28) (the fixnum ,thing)))

;;; Bits 24-26 (inclusive) of a memory-spec define the type of memory-spec in question.
(defconstant memspec-type-byte (byte 3 24))
(defmacro memspec-type (memspec)
  `(ldb memspec-type-byte (the fixnum ,memspec)))

;;; A slot in the value-stack frame.  This needs to get interpreted
;;; relative to the top of the vsp.  The low 15 bits denote the
;;; offset in the frame; the low 2 bits are always clear, since the
;;; vstack is always aligned on a 32-bit boundary.
(defconstant memspec-frame-address 0)


;;; Address-specs - whether memory- or register-based - might be used to indicate the
;;; canonical address of a variable.  Sometimes, this address is actually the address
;;; of a "value cell" object; if so, bit 27 will be set in the indicated address.

(defun ppc-addrspec-vcell-p (x)
  (logbitp 27 x))

(defmacro make-vcell-memory-spec (x)
  `(logior (ash 1 27) (the fixnum ,x)))

(defmacro memspec-frame-address-offset (m)
  `(logand (the fixnum ,m) #xffff))


(ccl::provide "PPC-REG")
