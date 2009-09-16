;;-*- Mode: Lisp; Package: ccl -*-

;;	Change History (most recent first):
;;  $Log: l1-edfrec.lisp,v $
;;  Revision 1.41  2006/04/03 00:02:54  alice
;;  ; add variable *redraw-whole-line* - if T makes arabic and hebrew draw better but cursor still screwed up
;;
;;  Revision 1.40  2006/03/26 21:43:48  alice
;;  don't remember
;;
;;  Revision 1.39  2006/03/21 01:50:44  alice
;;  ;; experimental-draw-text, xtext-width, and xpixel-2-char use ATSU stuff if not truly MacRoman
;;
;;  Revision 1.38  2006/02/19 22:26:44  alice
;;  ;; fix where-to-word-wrap
;;
;;  Revision 1.37  2006/02/03 00:49:09  alice
;;   ;; move without-interrupts in %scroll-screen-rect ???
;;-------- 5.2b1
;; frec-click - dont bother to set fr.cticks - it isn't used, use (get-tick-count) vs. (#_tickcount)
;;
;;  Revision 1.36  2005/11/29 20:57:14  alice
;;   ;; *italic-i-beam-cursor* setup is function of new-headers
;;
;;  Revision 1.35  2005/11/12 20:50:50  alice
;;   #\newline -> #\return
;;
;;  Revision 1.34  2005/09/10 09:35:52  alice
;;  ;; fix error string in %bwd-screen-line-start
;; grafport-global-origin - use accessor for pixmap.bounds
;;
;;  Revision 1.33  2005/05/22 03:51:48  alice
;;  dont remember
;;
;;  Revision 1.32  2005/04/19 07:01:54  alice
;;  ;; fix flagged-linewidth in %compute-screen-line, fix #\tab in %redraw-screen-lines
;;
;;  Revision 1.31  2005/03/27 22:01:59  alice
;;  ;; xpixel-2-char - use same criteria as experimental-draw-text
;;
;;  Revision 1.30  2005/03/20 01:19:37  alice
;;  ;; experimental-draw-text - use quickdraw vice drawthemetextbox more often
;;
;;  Revision 1.29  2005/03/13 21:40:35  alice
;;  ;; xpixel-2-char different for macsymbol and macdingbats
;;
;;  Revision 1.28  2005/03/12 04:24:29  alice
;;  ;; sort out difference between encoding and script in some places that set keyscript
;;
;;  Revision 1.27  2005/03/04 01:11:22  alice
;;  ;; buffer-find-font-in-script
;;
;;  Revision 1.26  2005/02/01 06:57:29  alice
;;  ;; unicode stuff - fix experimental-draw-roman and xtext-width
;
;;
;;  Revision 1.25  2004/12/20 21:43:58  alice
;;  ;; 12/14/04 buffer-find-font-in-script - forget extended-string-script
;; 12/10/04 eol stuff
;;
;;  Revision 1.24  2004/11/05 20:02:38  alice
;;  ; make frec-click work for multiple clicks and selection keep up with mouse ...
;;
;;  Revision 1.23  2004/10/03 06:11:41  alice
;;  ; make frec-click usage of wait-mouse-up-or-moved more politically correct, and set selection before update
;;
;;  Revision 1.22  2004/09/19 01:08:06  alice
;;  ; %screen-selection-region - beware line width > 32767 pixels
;;
;;  Revision 1.21  2004/09/11 03:51:10  alice
;;  ; frec-click again
;;
;;  Revision 1.20  2004/09/08 02:40:37  alice
;;  ; frec-click - don't do fake-mouse-moved - doesn't always dtrt on OSX
;;
;;  Revision 1.19  2004/09/07 01:37:33  alice
;;  ; bp-and-caret is woi, uses with-pen-saved-simple
;;
;;  Revision 1.18  2004/08/05 20:44:27  alice
;;  ; fixed screwed up edit of clear-screen-band - broke printing
;;
;;  Revision 1.17  2004/08/05 20:25:32  alice
;;  ; fixed screwed up edit of clear-screen-band - broke printing
;;
;;  Revision 1.16  2004/07/15 20:22:26  alice
;;  ; only fake-mouse-moved if timer is installed
;;
;;  Revision 1.15  2004/07/04 08:15:59  alice
;;  ; delete some #-carbon-compat
;;
;;  Revision 1.14  2004/04/09 02:09:04  alice
;;  ; 04/08/04 use wait-mouse-up-or-moved vs mouse-down-p
;;
;;  Revision 1.13  2004/03/28 07:54:38  alice
;;  ; 03/27/04 frec-click now ok when timer is running
;;
;;  Revision 1.12  2004/03/27 21:56:09  alice
;;  ; 03/26/04 frec-click trying to do fred-autoscroll-v-p and h-p - not quite right?
;;
;;  Revision 1.11  2004/02/19 21:06:33  alice
;;  ; 02/18/04 use mouse-down-p vs #_waitmouseup
;;
;;  Revision 1.10  2004/02/05 03:04:52  alice
;;  ; 02/04/04 (method .. => (reference-method ..
; 02/04/04 %frec-update-internal - don't mess with #_normalizethemedrawingstate
;;
;;  Revision 1.9  2003/12/08 08:36:27  gtbyers
;;  Use %remove-standard-method-from-containing-gf, not %remove-method.
;;
;;  5 10/5/97  akh  see below
;;  4 4/1/97   akh  see below
;;  25 1/22/97 akh  add a new fred command meta-j which toggles between
;;                  1) a click in fred window sets the keyscript to the script of the neighboring font
;;                  2) a click in fred window leaves the keyscript unchanged. The font inherits as usual. 
;;                  the initial behavior is 1 above
;;
;;  22 9/15/96 akh  make-frec - revert to old def (no frec-list unless wptr)
;;  21 9/4/96  akh  beats me
;;  20 7/18/96 akh   restore an optimization in %bwd-screen-line-start
;;                  ;     fix frec-show-cursor for a 1 line frec that is slightly too small
;;                  ;     fix screen-line-width for last line in wrapped buffer
;;
;;  19 6/16/96 akh  minor optimizations
;;  18 6/7/96  akh   buffer-find-font-in-script uses fn (extended-string-script) vs var
;;
;;  16 5/20/96 akh  %compute-screen-line - fussier about para-frec end if didn't end with newline
;;  12 2/6/96  akh  %bwd-screen-line-start linevec buffer was too small by 1 or 2
;;  11 1/28/96 akh  frec-update passes no-drawing to frec-update of other frecs
;;                  %update-screen-lines and %screen-point dtrt if cursor (..er caret) is out of sight
;;  10 12/24/95 akh update-key-script-from-click - dont call buffer-char if pos is buffer-size
;;  8 12/1/95  akh  %i+
;;  7 11/19/95 gb   no change
;;  3 10/17/95 akh  merge patches
;;  2 10/9/95  akh  newer version of the file
;;  40 9/14/95 akh  make-frec - fr.caret-on-p initially nil
;;  39 9/14/95 akh  remove some calls to with-frec
;;  38 9/14/95 akh  update-key-script-from-click had a bug
;;  37 9/11/95 akh  faster scroll up when wrapped.
;;  36 9/11/95 akh  call-with-frec didnt need the setclip business
;;  35 8/18/95 akh  %update-screen-lines - when wrapped, invalidate to newline after zmod.
;;  34 7/27/95 akh  set-hscroll and add-hscroll - no error if out of bounds, just truncate
;;  32 7/27/95 akh  frec-activate - if view is current-key-handler, changes key script to the script appropriate to the buffer.
;;                  %hscroll-screen doesnt scroll curpoint if "unknown" ie -1,-1
;;  31 7/27/95 akh  ; frec-idle - only mess with key-script if has changed via user switching kbds
;;  30 6/10/95 akh  %compute-screen-lines - redraw whole line if right or center justified
;;  28 5/31/95 akh  frec-click - dont update inside the loop unless something changes
;;  27 5/30/95 akh  fix previous fix so that we dont redraw too many lines
;;                  Maybe fix Arabic blink
;;  26 5/26/95 akh  in update-screen-lines - zmod:zwin dont back up past end of line containing zmod.
;;  25 5/24/95 akh  frec-up-to-date-p checks bmod of buffer vs frec
;;                  fix update-screen-lines for wrap - invalid to max of zmod and next eol
;;  24 5/23/95 akh  maybe no change
;;  23 5/22/95 akh  handler-bind vs. ignore-errors in %frec-update-internal - pushes errors onto *error-log*
;;  22 5/19/95 akh  fix flickering fred-dialog-items - check for new-lines = 0 at draw-bottom
;;  21 5/19/95 akh  just #+testing stuff
;;  20 5/17/95 akh  fix for scrolling  down while output to middle
;;  19 5/15/95 akh  more fixes for scrolling during output
;;  18 5/10/95 akh  added fr.truezwin, fixes for scrolling while modifying
;;  16 5/4/95  akh  fix frec-screen-line-vpos to check if up to date
;;  15 5/4/95  akh  change in #+testing
;;  14 5/2/95  akh  frec update draws now to fix scrolling from beneath a windoid
;;  13 5/1/95  akh  without-interrupts  around a few (frec-update)(do-something-that-expects-up-to-date)
;;  12 4/28/95 akh  move binding of blinkers on, minor change to screen-caret-on
;;  11 4/26/95 akh  error "shouldn't" vs stack overflow
;;  10 4/24/95 akh  No more fr.zwin-return-p, condense blinker stuff
;;  9 4/10/95  akh  fix sometimes missing end of window on resize
;;  8 4/7/95   akh  without-interrupts in %screen-char-pos-internal
;;  6 4/6/95   akh  frec click - gotta move more than 1 pixel to select a char
;;  5 4/6/95   akh  hit the "shouldn't happen" problem with a hammer - hope its not a boomerang
;;  4 4/4/95   akh  fix slowness when wrap-p, add frec-up-to-date-p and use it
;;  19 3/22/95 akh  make blinkers work in a brute force way
;;                  fix guys who expect an empty last line (isnt always there)
;;  18 3/20/95 akh  initial fr.hpos and fr.margin both 3 vs 2 and 4
;;                  fix case of bmod past visible screen
;;                  try to fix blinkers
;;  17 3/15/95 akh  frec-update does draw when horizontal scroll occurs
;;  16 3/14/95 akh  use new -screen-lines for everything
;;  15 3/2/95  akh  new version of %update-screen-lines (currently only called when f = frec)
;;                  fix cursor at end of buffer (fix isnt quite right yet)
;;                  fix frec-pos-visible-p to check horizontal position too
;;                  fix frec-set-size to redo wrapping if necessary
;;  14 2/17/95 akh  Don't invalrgn in scroll-screen-vertically, do scroll visrgn correctly in %scroll-screen-rect
;;  13 2/9/95  akh  probably no change
;;  12 2/6/95  akh  scroll-screen-vertically invals the scrolled invalid region. Fixes bad update when an inactive window scrolls.
;;  11 2/2/95  akh  add bill's color stuff
;;  10 1/30/95 akh  fix bug in %update-screen-lines
;;  8 1/11/95  akh  put the modeline back at top
;;  7 1/11/95  akh  comment out cerror in update-screen-lines - it happens
;;  14 2/17/95 akh  Don't invalrgn in scroll-screen-vertically, do scroll visrgn correctly in %scroll-screen-rect
;;  13 2/9/95  akh  probably no change
;;  12 2/6/95  akh  scroll-screen-vertically invals the scrolled invalid region. Fixes bad update when an inactive window scrolls.
;;  11 2/2/95  akh  add bill's color stuff
;;  10 1/30/95 akh  fix bug in %update-screen-lines
;;  8 1/11/95  akh  put the modeline back at top
;;  7 1/11/95  akh  comment out cerror in update-screen-lines - it happens
;;  (do not edit before this line!!)

(in-package :ccl)

; Copyright 1989-1994 Apple Computer, Inc.
; Copyright 1995-2006 Digitool, Inc.

; Modification History
;; do ps-cursors here - not in resource fork today
;; fix bug in where-to-word-wrap
;; different fix in %update-lines-maybe ??
;; ----- 5.2b6
;; frec-click - when growing selection off top or bottom, increase scroll amount as time goes by
;; ------ 5.2b5
;; %update-lines-maybe does invalidate-view if scrolled - trying to fix partial line not drawn bug
;; pass ff and ms to xpixel-2-char, xpixel-2-char fudge for size <= 12
;;*italic-i-beam-cursor* - definition of type :bits16 is now fixed
;; %redraw-screen-lines - also fix for line longer than 255 chars
;; ------- 5.2b4
;; %redraw-screen-lines - fix for terminator #\tab
;; experimental-draw-text - do nothing if numchars not >= 0
;; frec-idle changes keyscript independent of encoding
;; fudge xtext-width etc for bold, when not using quickdraw
;; use ATSU for draw and measure MacRoman if *use-quickdraw-for-roman* is nil
;;------- 5.2b3
;; add variable *redraw-whole-line* - if T makes arabic and hebrew draw better but cursor still screwed up
;; experimental-draw-text gets optional args ff and ms
;; experimental-draw-text, xtext-width, and xpixel-2-char use ATSU stuff if not truly MacRoman
;; fix where-to-word-wrap
;; move without-interrupts in %scroll-screen-rect ???
;;-------- 5.2b1
;; frec-click - dont bother to set fr.cticks - it isn't used, use (get-tick-count) vs. (#_tickcount)
;; *italic-i-beam-cursor* setup is function of new-headers
;; xtext-width - don't crash if numchars <= 0, where-to-wrap quits when guess-chars <= 0
;; #\newline -> #\return
;; fix error string in %bwd-screen-line-start
;; grafport-global-origin - use accessor for pixmap.bounds
;; no change
;; fix flagged-linewidth in %compute-screen-line, fix #\tab in %redraw-screen-lines
;; xpixel-2-char - use same criteria as experimental-draw-text
;; experimental-draw-text - use quickdraw vice drawthemetextbox more often
;; xpixel-2-char different for macsymbol and macdingbats
;; sort out difference between encoding and script in some places that set keyscript
;; buffer-find-font-in-script 
;; unicode stuff - fix experimental-draw-roman and xtext-width
;; 12/14/04 buffer-find-font-in-script - forget extended-string-script
;; 12/10/04 eol stuff 
;; -------- 5.1 final
; make frec-click work for multiple clicks and selection keep up with mouse ...
; ------ 5.1b4
; make frec-click usage of wait-mouse-up-or-moved more politically correct, and set selection before update
;; ------- 5.1b3
; %screen-selection-region - beware line width > 32767 pixels 
; frec-click again
; frec-click - don't do fake-mouse-moved - doesn't always dtrt on OSX
; bp-and-caret is woi, uses with-pen-saved-simple
; fixed screwed up edit of clear-screen-band - broke printing (cvs sucks)
; only fake-mouse-moved if timer is installed
; delete some #-carbon-compat
; --------- 5.1b2
; 04/08/04 use wait-mouse-up-or-moved vs mouse-down-p
; 03/27/04 frec-click now ok when timer is running 
; 03/26/04 frec-click trying to do fred-autoscroll-v-p and h-p - not quite right?
; 02/18/04 use mouse-down-p vs #_waitmouseup
; 02/04/04 (method .. => (reference-method ..
; 02/04/04 %frec-update-internal - don't mess with #_normalizethemedrawingstate
;; --------- 5.1b1
; 10/28/03 theme things don't require osx-p
; include patch to update-key-script-from-click
; frec-click - without-interrupts -> without-event-processing or maybe progn
; --------- 5.0 final
; akh define variable *is-normalized* here
; ------- 5.0b4
; %update-hscroll does invalidate-view if OSX-P - fix when extending selection causes horiz scroll - UGH why???
; ----------- 4.4b5
; frec-activate don't do caret-on unless = key-handler
; ------- 4.4b4
; %frec-update-internal is theme-background aware
; ------- 4.4b3
; something broken here re horizontal scroll and osx - "fixed" in track-scroll-bar of fred-h-scroll-bar
; frec-click is woi for carbon - dunno
; some carbon accessor-calls junk
; akh pass script to char-byte
; 02/19/00 akh lmgetticks => tickcount
; 07/22/99 akh %bwd-screen-line-start - fix the "should have returned already" bug we hope
; --------- 4.3f1c1
; 10/28/98 akh %frec-update-internal - if no-drawing just invalidate sel rgn
; 10/02/97 akh caret always drawn with xor (for charcoal os8) - there is no space between chars - YUCK
; 03/31/97  compute-font-run-positions - reset len when make a bigger vector
; 03/01/97 akh   %frec-update-internal check whether the current upddatergn truly intersects our frec
; 02/07/97 bill  Fix find-pcache-line and its users. This makes %bwd-screen-line-start
;                work even for paragraphs that wrap more than 128 lines.
;                Changes to: %compute-screen-line, %update-screen-lines, find-pcache-line,
;                find-pcache-next-line, %bwd-screen-line-start.
; 02/04/97 bill  screen-caret-off & screen-caret-on wrap their bodies with-foreground-rgb.
;                This makes the blinking character appear in the :text part-color if
;                it is in the default font color. They also set fr.bpchar-on-p to the
;                current state of the blinking character (true if the cursor is off and
;                blinking character is on, NIL otherwise).
;                new-toggle-screen-caret uses fr.bpchar-on-p to determine whether
;                to use #$patCopy and #$SrcBic or #$patbic and #$SrcOr. It used to
;                always use #$patXor and #$SrcXor. It also toggles fr.bpchar-on-p.
;                Wrap the body of bp-and-caret (with-fore-color *black-color* ...).
;                These changes make the cursor always black and the blinking character
;                always the correct color.
; -------------  4.0
; 09/25/96 bill  %screen-selection-region does the italic endcaps again unless there
;                are right-to-left font runs.
; 09/24/96 bill  frec-click calls the action-proc just before exiting from the loop.
;                This makes it update for the last auto-scroll.
; -------------  4.0b2
; akh  restore an optimization in %bwd-screen-line-start
;     fix frec-show-cursor for a 1 line frec that is slightly too small
;     fix screen-line-width for last line in wrapped buffer
; akh buffer-find-font-in-script uses fn (extended-string-script) vs var
; 05/27/96 bill frec-click calls fred-autoscroll-v-p & fred-autoscroll-h-p to determine
;               whether to auto scroll. Defaults methods return true.
; 04/23/96 akh  %compute-screen-line - fussier about para-frec end if didn't end with newline
; 04/11/96 bill Alice's fix for buffer-find-font-in-script
; 03/27/96 bill %frec-update-internal calls #_ObscureCursor only if the
;               window containing the frec is active.
; 03/26/96  gb  lowmem accessors.
; 11/08/95 bill  #_font2script -> #_FontToScript
;  5/05/95 slh   frec-screen-line-vpos: (not frec-up-to-date-p frec) -> (not (frec-up-to-date-p frec))
; --------------
; make sure frec is up to date in frec-set-size
; scroll-screen-vertically invals the scrolled invalid region
; 01/30/95 alice fix bug in %update-screen-lines
; 01/05/95 alice comment out some calls to set-buffer-insert-font-index (???)
; 01/05/95 alice change update-screen-lines to erase whole line at bmod if line height changing.
; 01/04/95 alice changed %screen-selection-region to not show to right margin if eol not in selection 
;    (for left to right anyway). And if first char is eol do show to right margin.
; 12/27/94 alice change $max-font-changes-per-line from 512 to 128 else stack over flow on meta-.
;		 p.s. stack overflow was very messy - had to kill the lisp. Not surprising really.
; 11/17/93 bill make-frec reads buffer-tabcount
; ------------- 3.0d13

;(defpackage :fred)
;(in-package :fred)

; l1-edfrec.lisp
;
; New fred redisplay code.


; frec-screen-lines def is temporary. Need to change the behavior
; of clicking in the page up or down region of the vertical scroll bar
; or typing c-v or m-v. Scrolling up (m-v) becomes much harder now.

; old "fr.xxx" accessors that do not exist anymore.
; (FR.CLIPPED-P FR.LINEHT FR.NEXT-FREC FR.NO-DRAWING-P FR.POSITION FR.WPTR)

; Clicking in the scroll-a-screen region of the vertical scroll bar 
; for a fred window now scrolls too far.

; m-v works incorrectly at the end of the buffer when there is not
; a complete screen. As a matter of fact, it will work incorrectly
; whenever there are variable line heights in the screen before what
; we can see. Must guess at a place, then change our guess. This really
; cries out for cacheing some info about lines above the screen.

; fred-vpos calls %screen-point. May need to be updated to pass
; a few more parameters.

; Need to handle tabs differently in right-to-left script runs.

; Don't correctly handle roman text in right-to-left font.
; Need to call #_FindScriptRun to seperate out that text.
; This will necessitate returning an array of scripts from
; compute-font-run-positions and using it in callers.

; set fontForce NIL when we're inside our code.
; Need to find #_GetScriptManagerVariable. New "ccl:interfaces;script.lisp"?

; test frec-show-cursor

; All of a sudden, moving the cursor (c-f, c-n, etc.) while the
; caret is off leaves a turd
; 
; meta-. on a definition that pops up the "choose one" window
; causes the right-hand side of the window to flicker.
; I think this is a problem with window-send-behind
;
; word wrap mode: Line break inserted between tabs. Should search out past all
; whitespace on the line. Let them report it as a bug.
;
; Character wrap: inserts blank line after typing last character in
; line.
;
; c-a & c-e Fred commands need to set fr.cursor-bol-p & fr.cursor-bol-p-valid
; check cursor position after c-f, c-b, c-n, c-p when at beginning of line and not.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "SCRIPT-MANAGER"))

(defvar *font-run-positions* nil)
(defvar *font-run-endpoints* nil)
(defvar *font-run-ordering* nil)

; one global cache for wrapped paragraph - just keeps line starts
; could package this into a structure - save some symbols - phooey

(defvar para-frec nil)
(defvar para-start nil)
(defvar para-end nil)
(defvar para-linevec (make-array 130)) ; 1 EXTRA
(defvar para-lines nil)

(defvar *is-normalized* nil)  ;; is this soon enuf

(defparameter *redraw-whole-line* t)  ;; added 2006/03/30



; some of us think this is a max for snarf-buffer-line
(eval-when (:compile-toplevel :execute)
  (require "FREDENV")
  
  (defmacro with-foreground-rgb (&body body)
    (let ((thunk (gensym)))
      `(let ((,thunk #'(lambda () ,@body)))
         (declare (dynamic-extent ,thunk))
         (funcall-with-foreground-rgb ,thunk))))
  (defmacro with-font-run-vectors (&body body)
  `(let ((*font-run-positions* (make-array $max-font-changes-per-line))
         (*font-run-endpoints* (make-array $max-font-changes-per-line))
         (*font-run-ordering* (make-array $max-font-changes-per-line)))
     (declare (dynamic-extent *font-run-positions* *font-run-endpoints*
                              *font-run-ordering*))
     ,@body))
) 

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defconstant $max-font-run-length 512)
  (defconstant $max-font-changes-per-line 128)
  )

#-bccl (defvar *frdebug* nil)

(defun fred-record-p (thing)
  (istruct-typep thing 'fred-record))

(ccl::set-type-predicate 'fred-record 'fred-record-p)

(defun frec-arg (thing)
  (if (typep thing 'fred-record)
    thing
    (ccl::%badarg thing 'fred-record)))

; WITH-FREC expands into a call to CALL-WITH-FREC
#|
(defun call-with-frec (frec thunk)
  (let ((frec-var (frec-arg frec))
        (rgn2 ccl::*temp-rgn*))
    (with-macptrs (rgn)
      (rlet ((penstate :penstate))
        (unwind-protect
          (progn
            (#_GetPenState penstate)
            (#_PenNormal)
            (setf (fr.flags frec-var)
                  (logand $fr.flags_non-drawing-bits-mask
                          (the fixnum (fr.flags frec-var))))
            (%setf-macptr rgn (#_NewRgn))
            (#_GetClip rgn)
            (#_SetRectRgn rgn2 #@(0 0) (fr.size frec-var))
            (#_SectRgn rgn2 rgn rgn2)
            (#_SetClip rgn2)
            (funcall thunk frec-var))
          (#_SetPenState penstate)
          (unless (%null-ptr-p rgn)
            (#_SetClip rgn)
            (#_DisposeRgn rgn)))))))
|#

(defun call-with-frec (frec thunk)
  (let ((frec-var (frec-arg frec)))
    (progn
      (rlet ((penstate :penstate))
        (unwind-protect
          (progn
            (#_GetPenState penstate)
            (#_PenNormal)
            (setf (fr.flags frec-var)
                  (logand $fr.flags_non-drawing-bits-mask
                          (the fixnum (fr.flags frec-var))))
            (funcall thunk frec-var))
          (#_SetPenState penstate))))))

(defun make-frec (cursor owner &optional (size (view-size owner)))
  (let* ((curpos (buffer-position cursor))
         (frec (cons-fred-record)))
    (setf (fr.cursor frec) cursor
          (fr.owner frec) owner
          (fr.size frec) size
          (fr.wposm frec) (make-mark cursor 0 t)
          (fr.selmarks frec) (list (cons (make-mark cursor curpos)
                                          (make-mark cursor curpos t)))
          (fr.lead frec) 0
          (fr.flags frec) 0
          (fr.tabcount frec) (buffer-tabcount cursor)
          (fr.wrap-p frec)(buffer-wrap-p cursor)
          (fr.word-wrap-p frec)(buffer-word-wrap-p cursor)
          ;(fr.justification frec)(buffer-justification cursor)
          ;(fr.line-right-p frec)(buffer-line-right-p cursor)  ;???
          (fr.hscroll frec) 0
          (fr.margin frec) 3
          (fr.plist frec) nil
          (fr.bticks frec)  0 ;(#_TickCount)
          (fr.cticks frec) -1
          (fr.cposn frec) -1
          (fr.bpoint frec) -1
          (fr.bpos frec) nil
          (fr.curpoint frec) -1
          (fr.curcpos frec) 0
          (fr.hpos frec) 3  ; should be same as margin
          (fr.linevec frec) nil
          (fr.numlines frec) 0
          (fr.bwin frec) 0
          (fr.zwin frec) 0
          (fr.truezwin frec) 0
          (fr.bmod frec) 0
          (fr.zmod frec) 0
          (fr.selrgn frec) (%null-ptr)
          (fr.selposns frec) (list (cons curpos curpos))
          
          (fr.bpchar frec) nil
          (fr.bp-ff frec) 0
          (fr.bp-ms frec) 0
          (fr.vpos frec) 0)
    (setf (fr.caret-on-p frec) NIL)
    (%set-frec-justification frec (buffer-justification cursor))
    (setf (fr.numlines frec) 0)
    (let ((line-count (estimate-line-count frec)))
      (declare (fixnum line-count))
      (setf (fr.linevec frec) (make-array line-count :initial-element 0))
      (setf (fr.lineascents frec) (make-array line-count :initial-element 0))
      (setf (fr.linedescents frec) (make-array line-count :initial-element 0))
      (setf (fr.lineheights frec) (make-array line-count :initial-element 0))
      (setf (fr.linewidths frec) (make-array line-count :initial-element 0)))
    (when (setf (fr.line-right-p frec) (not (eql 0 (ccl::get-sys-just))))      
      (setf (fr.right-justified-p frec) t))
    (setf (fr.leading frec) nil)       ; no leading
    (when (and owner (wptr owner))
      (reinit-frec frec owner))     ; Push onto *frec-list*, allocate selrgn
        
    (ccl::use-buffer cursor)                 ; increment buffer reference count
    frec))



(defun estimate-line-count (frec)
  (multiple-value-bind (ff ms) (ccl::buffer-font-codes (fr.cursor frec))
    (with-focused-view nil
      (with-font-codes ff ms
        (multiple-value-bind (a d) (font-info)
          (max 2
               (ceiling (point-v (fr.size frec)) (+ a d))))))))

; Add the leading to the descent as specified by (fr.leading frec).
; fr.leading can be:
;   NIL    - no leading
;   T      - use font-specified leading
;   fixnum - use that many points of leading
;   float  - multiply font-specified leading by the float.
(defun new-frec-add-leading (frec descent leading)
  (let ((fr-leading (fr.leading frec)))
    (cond ((null fr-leading) descent)
          ((eq t fr-leading) (+ descent leading))
          ((floatp fr-leading) (+ descent (round (* fr-leading leading))))
          ((fixnump fr-leading) (%i+ descent fr-leading))
          (t (error "Illegal value of ~s: ~s" 'fr.leading fr-leading)))))

;Make a gcable new region
(defun %new-rgn ()
  (let ((rgn (ccl::make-gcable-macptr ccl::$flags_DisposHandle)))
    (%setf-macptr rgn (#_NewRgn))
    (when (%null-ptr-p rgn)
      (error "Unable to allocate region."))
    rgn))

(defvar *sel-region* nil)

(ccl::def-ccl-pointers new-frec ()
  (setq *sel-region* (%new-rgn)))

(defvar *frec-list* nil)

(defmacro do-all-frecs (frec-var &body body &aux result-forms)
  (when (listp frec-var)
    (setq result-forms (cdr frec-var)
          frec-var (car frec-var)))
  `(dolist (,frec-var *frec-list* (progn ,@result-forms))
     ,@body))

(defun map-frecs (function)
  (do-all-frecs frec (funcall function frec)))

(defun %check-frec-selrgn (frec rgn)
  (unless (handlep rgn)
    (error "Invalid selection region in ~S" frec)))

(defun kill-frec (frec &optional save-buffer-p)
  (frec-arg frec)
  (without-interrupts
   (setq *frec-list* (delq frec *frec-list*))
   (unless save-buffer-p
     (ccl::unuse-buffer (fr.cursor frec)))
   (let ((rgn (fr.selrgn frec)))
     (unless (%null-ptr-p rgn)
       (%check-frec-selrgn frec rgn)
       (ccl::set-macptr-flags rgn ccl::$flags_Normal)   ; turn off auto-dispose by GC
       (#_DisposeRgn rgn)
       (%setf-macptr rgn (%null-ptr)))))
  frec)

(defun reinit-frec (frec owner-or-wptr &optional (owner nil owner-p))
  (frec-arg frec)
  (unless owner-p
    (setq owner owner-or-wptr))         ; backward compatibility.
  (let ((cursor (fr.cursor frec)))
    (unless (typep cursor 'buffer-mark)
      (ccl::report-bad-arg cursor 'buffer-mark)))
  (setf (fr.owner frec) owner)
  (let ((rgn (fr.selrgn frec)))
    (when (or (eq (ccl::%type-of rgn) 'dead-macptr)  ; may have been in a saved world
              (%null-ptr-p rgn))
      (setf (fr.selrgn frec) (setq rgn (%new-rgn)))
      (setf (fr.sel-valid-p frec) nil))
    (%check-frec-selrgn frec rgn))
  (without-interrupts
   (pushnew frec *frec-list*))
  (when (and (view-size owner) (view-position owner))
    (with-focused-view owner
      (%update-resized-lines frec)))
  (setf (fr.bmod frec) 0
        (fr.zmod frec) 0) 
  frec)

(defun kill-frec-list ()
  (loop
    (when (null *frec-list*) (return))
    (kill-frec (car *frec-list*))))

(defun shared-buffer-p (buffer &aux found)
  (do-all-frecs frec
    (when (same-buffer-p buffer (fr.buffer frec))
      (if found
        (return t)
        (setq found t)))))

(defun frec-get-sel (frec)
  (let* ((marks (car (fr.selmarks frec)))
         (beg (%buffer-position (car marks)))
         (end (%buffer-position (cdr (the list marks)))))
    (when (<= end beg)
      (setq beg (setq end (%buffer-position (fr.cursor frec)))))
    (values beg end)))

(defun frec-set-sel (frec &optional pos curpos)
  ;(frec-arg frec)
  (let* ((marks (car (fr.selmarks frec)))
         (cursor (fr.cursor frec)))
    (setq pos (buffer-position cursor pos))
    (when curpos (set-mark cursor curpos))
    (setq curpos (%buffer-position cursor))
    (set-mark (car marks) (min pos curpos))
    (set-mark (cdr marks) (max pos curpos))
    (rplacd (fr.selmarks frec) nil)
    pos))

; don't mess with the cursor
(defun frec-set-sel-simple (frec &optional start end)
  ;(frec-arg frec)
  (when (not start) (setq start (%buffer-position (fr.cursor frec))))
  (when (not end) (setq end start))
  (let* ((marks (car (fr.selmarks frec))))
    (set-mark (car marks) (min start end))
    (set-mark (cdr marks) (max start end))
    (rplacd (fr.selmarks frec) nil)
    start))

(defun frec-size (frec)
  (fr.size (frec-arg frec)))

(defun frec-up-to-date-p (frec)
  (let* ((buf (fr.cursor frec))
         (bmod (%buf-bmod buf)))  ; 5/23
    (and (eql bmod #xffffff)  ; i think we mean bmod of buffer
         (let ((pos (%buffer-position (fr.wposm frec))))
           (eql (fr.bwin frec) pos)))))

#|
(defun frec-up-to-date-p (frec)
  (and (eql (fr.bmod frec) #xffffff)  ; i think we mean bmod of buffer
       (let ((pos (%buffer-position (fr.wposm frec))))
         (eql (fr.bwin frec) pos))))
|#

; *** may need to be called focused on the frec's owner - does
;    (used to include a WITH-PORT)
(defun frec-set-size (frec h &optional v)
  (frec-arg frec)
  (let ((blinkers-on (fr.caret-on-p frec)))
    (setq h (make-point h v))
    (without-interrupts
     (unwind-protect
       (progn     
         (%frec-turn-off-blinkers frec)   
         (setq v (fr.size frec))
         (unless (eql h v)     
           (setf (fr.size frec) h)
           ; *** How does this work?
           (rplacd (car (fr.selposns frec)) #x1000000)         ; recompute selections...
           (cond ((and (or (fr.wrap-p frec)
                           (fr.center-justified-p frec) 
                           (fr.right-justified-p frec))
                       (not (eql (point-h h) (point-h v))))
                  (setf (fr.bmod frec) 0)  ; make sure it really updates
                  (setf (fr.zmod frec) 0)
                  (frec-update frec t))
                 ((not (eql (point-v h) (point-v v)))
                  (let ((buf (fr.cursor frec)))
                    (if (frec-up-to-date-p frec)
                      ;if frec is up to date (for old size) then be smarter
                      (if (> (point-v h) (point-v v))  ; if got bigger, redo zwin to end - zwin??
                        (setf (fr.bmod frec)(- (buffer-size buf)(fr.zwin frec))
                              (fr.zmod frec) 0)
                        ; if got smaller - fix numlines and zwin
                        (let* ((linevec (fr.linevec frec))
                               (lineheights (fr.lineheights frec))
                               (numlines (fr.numlines frec))
                               (line-num 0)
                               (max-y (point-v h))
                               (y 0)
                               (pos (fr.bwin frec)))
                          (loop
                            (when (>= line-num numlines) (return))
                            (when (>= y max-y)
                              (when nil (and (> pos 0) (char-eolp (buffer-char buf (1- pos)) ))
                                (decf pos)
                                (setf (fr.zwin-return-p frec) t))
                              (setf (fr.zwin frec) (- (buffer-size buf) pos)
                                    (fr.numlines frec) line-num)
                              (return))                      
                            (incf pos (linevec-ref linevec line-num))
                            (incf y (linevec-ref lineheights line-num))
                            (incf line-num 1))))                        
                      ; if not up to date be dumber - all needs redo
                      (setf (fr.bmod frec)(fr.bwin frec)
                            (fr.zmod frec) 0)))
                  (frec-update frec nil)            
                  ))))
       (when blinkers-on (screen-caret-on frec))))))
 ;(setf (fr.caret-on-p frec) t))))))
            



(defun get-region-bounds-tlbr (region)
    #+carbon-compat
    (rlet ((rect :rect))
      (#_getregionbounds region rect)
      (values (pref rect :rect.topleft)(pref rect :rect.botright)))
    #-carbon-compat
    (values (href region :region.rgnBbox.topLeft)(href region :region.rgnbbox.botRight)))



(defun grafport-visible-corners ()
  (let ((rgn ccl::*temp-rgn*))
    (let* ((visrgn ccl::*temp-rgn-3*))
      (with-port-macptr port
        (#_getportclipregion port rgn)
        (#_getportvisibleregion port visrgn)
        (#_sectrgn visrgn rgn rgn)
        (get-region-bounds-tlbr rgn)))))


;; getportbounds aint the same 

(defun grafport-global-origin ()
  (with-port-macptr port     
    (with-macptrs ((pixmap (#_getportpixmap port)))
      (rlet ((bounds :rect))
        (#_GetPixBounds pixmap bounds)
        (pref bounds :rect.topleft))))) 

; Must be focused when this is called.
; Copied from old version. May not make sense any more.
(defun frec-draw-contents (frec &optional refresh?)
  ;(setq frec (frec-arg frec))
  (unless (%null-ptr-p (fr.selrgn frec))
    (without-interrupts
     (when refresh?  ; dont think this arg is used
       (%update-resized-lines frec)
       (setf (fr.bmod frec) 0
             (fr.zmod frec) 0))
     (frec-update frec t)
     (with-frec (frec frec)
       (%frec-draw-contents-internal frec)))))

; this no drawing business is sort of iffy now because we are assuming that
; the chars before bmod are on the screen 
(defun frec-update (frec &optional no-drawing)
  ;(frec-arg frec)  
  (unless (%null-ptr-p (fr.selrgn frec))
    (without-interrupts
     ; fr.xMOD is the changed region from frec's last display to some time T.
     ; BF.xMOD is the changed region from time T to now.
     ; The time T is the same for all frecs on the same buffer.  To update
     ; one frec, we add the buffer's changed region to the changed regions of
     ; each frec viewing that buffer and clear the buffer's changed region.
     ; In effect we are changing the time T for that buffer to be Now.
     (let* ((buf (fr.cursor frec))
            (bmod (%buf-bmod buf))
            (zmod (%buf-zmod buf)))
       (unless (eql bmod #xffffff)
         (setf (%buf-bmod buf) #xffffff
               (%buf-zmod buf) #xffffff)
         (dolist (other-frec *frec-list*)
           (when (same-buffer-p buf (fr.cursor other-frec))
             (setf (fr.bmod other-frec) (min (fr.bmod other-frec) bmod)
                   (fr.zmod other-frec) (min (fr.zmod other-frec) zmod)))))       
       (%frec-update-internal frec no-drawing)
       (unless (eql bmod #xffffff)
         (dolist (other-frec *frec-list*)
           (unless (eq frec other-frec)
             (when (same-buffer-p buf (fr.cursor other-frec))
               (with-focused-view (fr.owner other-frec)
                 (%frec-update-internal other-frec no-drawing))))))))))

(defvar *error-log* nil)
(defun %frec-update-internal (frec no-drawing)  
  (progn ;with-frec (frec frec)
    (handler-bind ((error 
                    #'(lambda (c) 
                        (push c *error-log*)
                        (validate-view (fr.owner frec))  ; good luck
                        (return-from %frec-update-internal nil))))
      (let ((bmod (fr.bmod frec))
            (blinkers-on (fr.caret-on-p frec))
            h-scrolled
            old-state)
        (declare (fixnum bmod))
        (declare (ignore-if-unused h-scrolled old-state))        
        (unless (eql #xffffff bmod)
          ; set buf-changed-p bit if the buffer was modified
          (setf (fr.buf-changed-p frec) t)
          (let ((curcpos (fr.curcpos frec)))
            (declare (fixnum curcpos))
            (when (>= curcpos bmod)
              ; set curs-changed-p bit if the mod was before the cursor
              (setf (fr.curs-changed-p frec) t)
              (when (and (eql curcpos bmod) ccl::*foreground*)
                (let* ((owner (fr.owner frec))
                       (window (and owner (view-window owner))))
                  (when (or (null window) (window-active-p window))
                    ; hide cursor if change was at cursor
                    (#_ObscureCursor)))))))
        (unwind-protect
          (progn
            (setf (fr.nodrawing-p frec) no-drawing)
            (%frec-turn-off-blinkers frec)
            ;Set sel-valid-bit if shape unchanged and all positions were before bmod. 
            (when (eq (fr.framed-sel-p frec) (fr.frame-sel-p frec))
              (dolist (sel (fr.selposns frec)
                           (setf (fr.sel-valid-p frec) t))
                (declare (list sel))
                (when (or (<= bmod (car sel)) (<= bmod (cdr sel)))
                  (return))))
            ;Update hpos setting per hscroll
            (let ((new-hscroll (- (fr.margin frec) (fr.hscroll frec))))
              (declare (fixnum new-hscroll))
              (unless (eql new-hscroll (fr.hpos frec))
                (setq h-scrolled t)
                (%update-hscroll frec)))
            ;update lines
            ; some call to with-frec above here clobbers this so put it back!
            ; maybe frec-turn-off-blinkers was only culprit
            (setf (fr.nodrawing-p frec) no-drawing)
            (%update-lines-maybe frec bmod)
            
            ;Update cursor
            ;*** need to add split cursor here.
            (let* ((buffer (fr.cursor frec))
                   (new-curcpos (%buffer-position buffer))
                   (cursor-bol-p (fr.cursor-bol-p frec))
                   (curcpos (fr.curcpos frec)))
              (declare (fixnum new-curcpos))
              (unless (and (not (fr.curs-changed-p frec))
                           (eql curcpos new-curcpos)
                           (if (null (fr.curpoint frec))
                             (not (fr.changed-p frec))
                             (not (eql (fr.curpoint frec) -1))))
                (dbmsg "~& Curpoint, old=~A"
                       (if (fr.curpoint frec) (point-string (fr.curpoint frec))))
                (unless (eql (fr.curcpos frec) new-curcpos)
                  (setf (fr.curs-changed-p frec) t)
                  (if (fr.cursor-bol-p-valid frec)
                    (setf (fr.cursor-bol-p-valid frec) nil)
                    (when (if (eql new-curcpos (1- curcpos))
                            (eql new-curcpos (nth-value 1 (frec-screen-line-num frec new-curcpos)))
                            (eql curcpos (nth-value 1 (frec-screen-line-num frec curcpos))))
                      (setq cursor-bol-p (setf (fr.cursor-bol-p frec) t)))))
                (setf (fr.changed-p frec) t)
                (setf (fr.curpoint frec) -1)
                (multiple-value-bind (curpoint cursor-line)
                                     (%screen-point frec new-curcpos cursor-bol-p)
                  (when curpoint
                    (setf (fr.curpoint frec)
                          (make-point (1- (point-h curpoint)) (point-v curpoint)))
                    (let ((pos (if (eql 0 new-curcpos) 0 (1- new-curcpos)))
                          max-ascent max-descent)
                      (multiple-value-bind (ff ms) 
                                           (if (>= pos (buffer-size buffer))
                                             (ccl::buffer-font-codes buffer)
                                             (ccl::buffer-char-font-codes buffer pos))
                        (multiple-value-bind (ascent descent) (font-codes-info ff ms)
                          (if cursor-line
                            (setq max-ascent (linevec-ref (fr.lineascents frec) cursor-line)
                                  max-descent (linevec-ref (fr.linedescents frec) cursor-line))
                            (multiple-value-setq (max-ascent max-descent)
                              (multiple-value-bind (ff ms) (ccl::buffer-font-codes buffer)
                                (font-codes-info ff ms))))
                          (setf (fr.curascent frec) (min ascent max-ascent)
                                (fr.curdescent frec) (min descent max-descent)))
                        (setf (fr.cursor-italic-p frec) (italic-ff-code-p ff))))))
                (setf (fr.curcpos frec) new-curcpos)
                (dbmsg " new=~A" (if (fr.curpoint frec)
                                   (point-string (fr.curpoint frec))))))
            ;Update bpchar
            (let (pos
                  (buffer (fr.cursor frec))
                  point)
              (unless (or (not (fr.changed-p frec))
                          (and (not (fr.buf-changed-p frec))
                               (not (fr.curs-changed-p frec))
                               (setq pos (fr.bpos frec))
                               (or (eql pos -1) (not (eql (fr.bpoint frec) -1)))))
                (when (null pos)
                  (let ((owner (fr.owner frec)))
                    (setq pos (and owner (fred-blink-position owner))))
                  (setf (fr.bpos frec) pos))
                (if (and pos 
                         (<= 0 (the fixnum pos))
                         (< pos (buffer-size buffer)))                         
                  (multiple-value-bind (ff ms) (ccl::buffer-char-font-codes buffer pos)
                    (if (setq point (%screen-char-point frec pos (ff-script ff)))
                      (progn
                        (setf (fr.bpoint frec) point)
                        (setf (fr.bpchar frec) (buffer-char buffer pos))
                        (setf (fr.bp-ff frec) ff)
                        (setf (fr.bp-ms frec) (make-point (point-h ms) #$SrcXor)))
                      (setf (fr.bpoint frec) -1)))                      
                  (setf (fr.bpoint frec) -1))))
            ;Update selection
            (unless (let* ((posns (fr.selposns frec))
                           (marks (fr.selmarks frec))
                           (valid (fr.sel-valid-p frec)))
                      (declare (cons posns) (list marks))
                      (loop
                        (let* ((posn (car posns))
                               (mark (car marks))
                               (car-pos (%buffer-position (car mark)))
                               (cdr-pos (%buffer-position (cdr mark))))
                          (declare (type cons posn mark)
                                   (fixnum car-pos cdr-pos))
                          ; I changed this. The old code made no sense to me.
                          (unless (and (eql (car posn) car-pos)
                                       (eql (cdr posn) cdr-pos))
                            (setf (car posn) car-pos
                                  (cdr posn) cdr-pos
                                  valid nil)))
                        (if (null (cdr posns))
                          (if (null (setq marks (cdr marks)))
                            (return valid)
                            (dolist (mark marks (return nil))
                              (declare (list mark))
                              (setf (cdr posns) (cons (%buffer-position (car mark))
                                                      (%buffer-position (cdr mark))))
                              (setq posns (cdr posns))))
                          (if (null (setq marks (cdr marks)))
                            (return (setf (cdr posns) nil))
                            (setq posns (cdr posns))))))
              (dbmsg "~& recompute sel")
              (setf (fr.changed-p frec) t
                    (fr.framed-sel-p frec) (fr.frame-sel-p frec))
              ; way up there about 10 pages ago we may or may not have turned it on -        
              (rotatef *sel-region* (fr.selrgn frec))
              (%screen-selection-region frec)
              (let ((rgn *sel-region*))
                (#_XorRgn rgn (fr.selrgn frec) rgn)
                (if no-drawing ;(fr.nodrawing-p frec)  ;; << was if nil - 10/98
                  (invalidate-region (fr.owner frec) rgn)
                  (progn
                    (#_LMSetHiliteMode (ccl::bitclr 7 (the fixnum (#_LMGetHiliteMode))))
                    (#_InvertRgn rgn))))
              ))          
          (when blinkers-on
            (screen-caret-on frec))
          (setf (fr.nodrawing-p frec) nil))
        ;If we got an update region, draw that... Is this right??? never does anything useful??
        ; dont do it - makes things ugly when e.g. meta-. opens a window 
        ; and then scrolls it. Let window-update-event-handler deal with redraw.
        ; But do it when horizontal scroll so we see new stuff now
        ; doing it now is also better when v-scroll with windoid atop
        ; but still worse when meta-. - so make meta-. a special case
        (when (and (not *gonna-change-pos-and-sel*) (not no-drawing))  ; ugh
          (let* ((offset (grafport-global-origin))
                 (rgn2 *temp-rgn-2*))
            (let ((tl (subtract-points #@(0 0) offset))
                  (br (subtract-points (fr.size frec) offset)))
              (#_SetRectRgn rgn2 (point-h tl)(point-v tl)(point-h br)(point-v br)))
            (subtract-points #@(0 0) offset) 
            (subtract-points (fr.size frec) offset)            
            (let* ((updatergn *temp-rgn-3*)
                   (wptr (wptr (fr.owner frec))))
              (get-window-updatergn wptr updatergn)
              (#_SectRgn rgn2 updatergn rgn2)
              (when (not (#_emptyrgn rgn2))
                (rlet ((rect :rect))
                  (#_getregionbounds updatergn rect)
                  (let* ((topleft (pref rect :rect.topleft))
                         (botright (pref rect :rect.botright)))
                    (%frec-draw-contents-internal 
                     frec (add-points topleft offset) (add-points botright offset))))))))
        ))))

;(defparameter *last-scroll-tick* 0)

(defun %update-lines-maybe (frec bmod) ; lets get out sooner if nothing to do
  (declare (ignore-if-unused bmod))
  (let* ((linevec (fr.linevec frec))
         (numlines (fr.numlines frec))
         (bwin (fr.bwin frec))
         (wpos (buffer-position (fr.wposm frec)))
         no-scroll)
    (declare (fixnum numlines))
    (declare (ignore-if-unused wpos bwin))
    #+ignore
    (setq no-scroll
          (and
           (<= bwin wpos)         ; and not scrolling up
           (or (eql bwin wpos)    ; and not scrolling down
               (and (neq numlines 0)
                    (< wpos (+ bwin (linevec-ref linevec 0)))))))
    #+ignore
    (when (and (eql bmod #xFFFFFF)    ; nothing changed
               (> numlines 1)
               no-scroll)
      (return-from %update-lines-maybe nil))
    ;(when (eq frec my-frec)(return-from %update-lines-maybe nil))
    (let* (;(numlines (fr.numlines frec))
           ;(linevec (fr.linevec frec))
           (ascents (fr.lineascents frec))
           (descents (fr.linedescents frec))
           (lineheights (fr.lineheights frec))
           (linewidths (fr.linewidths frec))
           (old-linevec (make-array numlines))
           (old-ascents (make-array numlines))
           (old-descents (make-array numlines))
           (old-lineheights (make-array numlines))
           (old-linewidths (make-array numlines)))
      (declare (dynamic-extent old-linevec old-ascents old-descents old-lineheights old-linewidths))
      (declare (fixnum numlines))
      ; do this before any scrolling - doesnt work
      (let ((total-height 0))
        (dotimes (i numlines)
          (let ((lineheight (linevec-ref lineheights i)))
            (incf total-height lineheight)
            (setf (linevec-ref old-linevec i) (linevec-ref linevec i)
                  (linevec-ref old-lineheights i) lineheight
                  (linevec-ref old-ascents i) (linevec-ref ascents i)
                  (linevec-ref old-descents i) (linevec-ref descents i)
                  (linevec-ref old-linewidths i) (linevec-ref linewidths i))))
        ;(when (eq frec my-frec)(return-from %update-lines-maybe nil))
        (%update-screen-lines
         frec old-linevec old-ascents old-descents old-lineheights old-linewidths
         total-height)
        (unless no-scroll
          #+ignore ;; doesn't help
          (with-port-macptr port
            (#_QDFlushPortBuffer port (%null-ptr)))
          (when nil ; (<= bwin wpos)   ;; ?? - heavy hammer when scrolling down - no don't
            (invalidate-view (fr.owner frec)))
          )
        ))))

(defun ff-script (ff)
  (ccl::font-2-script (point-v ff)))

(defun ff-left-to-right-p (ff)
  (eql 0 (ccl::get-script (ff-script ff) #$smScriptRight)))

; Return two values: ff & ms of font corresponding to the given script.
; Search backwards from pos, then try forwards, then get system font for
; the script.
(defun buffer-find-font-in-script (buf script &optional (pos (buffer-position buf)))
  (let ((cpos pos)
        cff)
    (block find-font
      (loop
        (setq cff (ccl::buffer-char-font-codes buf cpos))
        (when (eql script (ff-script cff))
          (return-from find-font))
        (unless (setq cpos (ccl::buffer-previous-font-change buf cpos))
          (return)))
      (setq cpos pos)
      (loop
        (unless (setq cpos (buffer-next-font-change buf cpos))
          (return))
        (setq cff (ccl::buffer-char-font-codes buf pos))
        (when (eql script (ff-script cff))
          (return-from find-font)))
      (setq cff nil))
    (multiple-value-bind (ff ms) (ccl::buffer-char-font-codes buf pos)
      (values
       (make-point (point-h ff)
                   (if cff
                     (point-v cff) 
                     (script-to-font-simple script)
                     ))
       ms))))

;This function should return the position of the blinking char,
;or -1 or NIL if nothing to blink.
;-1 means there's really no blinking char, so don't bother recomputing unless
;buffer changes or cursor moves.  NIL means there is no blinking char in
;the win-start/win-end range, but there may be elsewhere, so should recompute
;if window scrolls, even if buffer and cursor don't change.
;This function must not modify the buffer in any way, including moving the
;cursor, and it must not cause any display of the buffer.
;It is called with interrupts disabled.

(unless (fboundp 'fred-blink-position)

(defmethod fred-blink-position (w)
  (let ((frec (frec w)))
    (buffer-select-blink-pos (fr.cursor frec) (fr.bwin frec) (fr.zwin frec))))

(ccl::queue-fixup
 ; fred-mixin doesn't exist yet.
 (defmethod fred-blink-position ((w fred-mixin))
   (let ((frec (frec w)))
     (buffer-select-blink-pos (fr.cursor frec) (fr.bwin frec) (fr.zwin frec))))
 (let ((method (ignore-errors (reference-method fred-blink-position (t)))))
   (when method
     (ccl::%remove-standard-method-from-containing-gf method))))

)  ; end of unless

(unless (fboundp 'buffer-select-blink-pos)
  
  (defun buffer-select-blink-pos (buffer win-start win-end &aux curpos ch)
    (declare (ignore win-start win-end))
    (setq curpos (buffer-position buffer))
    (or (and (not (eql 0 curpos))
             (not (ccl::buffer-lquoted-p buffer (setq curpos (1- curpos))))
             (cond ((eq #\) (setq ch (buffer-char buffer curpos)))
                    (or (ccl::buffer-bwd-up-sexp buffer curpos) curpos))
                   ((or (eql #\" ch) (eql #\| ch))
                    (ccl::buffer-backward-search-unquoted buffer ch curpos))
                   (t nil)))
        -1))
  )

(defun italic-buffer-char-p (buf &optional pos)
  (and (<= 0 pos)
       (< pos (buffer-size buf))
       (italic-ff-code-p (ccl::buffer-char-font-codes buf pos))))

(defun italic-ff-code-p (ff)
  (not (eql 0 (logand #.(ash (cdr (assq :italic *style-alist*)) 8)
                      (point-h ff)))))

(defun %update-hscroll (frec)
  ;(frec-arg frec)
  (%hscroll-screen frec (- (fr.margin frec) (fr.hscroll frec)))
  (%update-resized-lines frec)
  ;; why is this needed???? - perhaps lose similar crock in TRACK-SCROLL-BAR for FRED-H-SCROLL-BAR
  (if t #|(osx-p)|# (invalidate-view (fr.owner frec))))

(defun %hscroll-screen (frec new-hpos &aux (h (- new-hpos (fr.hpos frec))))
    (setf (fr.changed-p frec) t)
    (setf (fr.hpos frec) new-hpos)
    (rlet ((rect :rect :topleft #@(0 0) :botright (fr.size frec)))     
      (let ((wptr (wptr (fr.owner frec))))
        (#_invalWindowRgn wptr (%scroll-screen-rect rect h 0 wptr)))
      (setf (fr.sel-valid-p frec) nil)
      (let ((selrgn (fr.selrgn frec))
            (rgn ccl::*temp-rgn*)
            (offset (make-point h 0)))
        (#_OffsetRgn selrgn h 0)
        (#_GetClip rgn)
        (#_SectRgn selrgn rgn selrgn)
        (unless (eql (fr.curpoint frec) #@(-1 -1))  ; <<
          (setf (fr.curpoint frec) (add-points (fr.curpoint frec) offset)))
        (setf (fr.bpoint frec) (add-points (fr.bpoint frec) offset)))))

(defun frec-screen-hpos (frec pos)
  (progn ;with-frec (frec frec)
    (let ((buf (fr.cursor frec)))
      (setq pos (buffer-position buf pos))
      (let* ((line-start (frec-screen-line-start frec pos))
             (line-end (frec-screen-line-start frec line-start 1)))
        (if (and (< pos (buffer-size buf))
                 (not (char-eolp (buffer-char buf pos)))
                 (neq line-start
                      (frec-screen-line-start frec (1+ pos))))
          (frec-hpos frec (1+ pos))
          (%screen-line-hpos frec line-start pos line-end))))))

(defun frec-hpos (frec pos)
  (progn ;with-frec (frec frec)
    (setq pos (buffer-position (fr.cursor frec) pos))
    (let* ((buf (fr.cursor frec))
           (line-start (buffer-line-start buf pos))
           (line-end (buffer-line-start buf line-start 1)))
      (%screen-line-hpos frec line-start pos line-end))))


(defparameter *temp-rgn-3* (#_newrgn)) ;; it's in l1-init too
;Scroll the rectangle, bringing the update region along.
;Leaves the clobbered region in *temp-rgn*
; nothing so fun as making code totally illegible
(defun %scroll-screen-rect (rect h v &optional wptr)  ;; not optional if carbon
  ;(declare (ignore-if-unused wptr))
  (without-interrupts
   (when (not (ok-wptr wptr)) (with-pstrs ((p "wptr required"))(#_debugstr p)))
   ;; this is screwed up carbon-wise - getting better  
   (let ((new-update-rgn ccl::*temp-rgn*)
         (rgn ccl::*temp-rgn-2*)       
         (rgn2 *temp-rgn-3*)
         (global-origin (grafport-global-origin)))
     ;(without-interrupts 
     (with-macptrs ((port (#_getWindowPort wptr)))
       (get-window-updatergn wptr new-update-rgn)
       (#_OffsetRgn new-update-rgn (point-h global-origin)(point-v global-origin))
       (#_RectRgn rgn rect)
       (#_SectRgn rgn new-update-rgn new-update-rgn)
       ; add invisible part of rect to update region
       (#_rectrgn rgn rect)    
       (#_diffrgn rgn (get-window-visrgn wptr rgn2) rgn)
       (#_unionrgn new-update-rgn rgn new-update-rgn)
       ;Add the clipped part of rect to the update region
       (#_rectrgn rgn rect)    
       (#_diffrgn rgn (#_getPortClipRegion port rgn2) rgn)
       (#_unionrgn new-update-rgn rgn new-update-rgn)
       ;"Scroll" the update region
       (#_rectrgn rgn rect)    
       (#_sectrgn rgn (#_getportClipRegion port rgn2) rgn)     
       (#_ValidWindowRgn wptr rgn)
       (#_offsetrgn new-update-rgn h v)
       (#_sectrgn new-update-rgn rgn new-update-rgn)    
       (#_InvalWindowRgn wptr new-update-rgn)
       ;Finally scroll the text
       (#_ScrollRect rect h v new-update-rgn)
       (when t #|(osx-p)|# (#_QDFlushPortBuffer Port (%null-ptr)))  ;; does this do any good?
       new-update-rgn))))



; I am suspicious of this thing - adjusts bmod and zmod for wrap-p frecs
(defun %update-resized-lines (frec)
  (when (fr.wrap-p frec)
    (let* ((pos (fr.bwin frec))
           (bmod (fr.bmod frec))
           (numlines (fr.numlines frec))
           (linevec (fr.linevec frec))
           (line-num 0)
           (y 0)
           (max-y (point-v (fr.size frec)))
           line-length ascent descent lineheight)
      (declare (ignore-if-unused ascent descent))
      (when (< pos bmod)
        (loop
          (when (>= line-num numlines) (return))
          (multiple-value-setq (line-length ascent descent lineheight)
            (%compute-screen-line frec pos))
          (when (or (eql line-length 0)
                    (not (eql line-length (linevec-ref linevec line-num)))
                    (>= (incf pos line-length) bmod)
                    (>= (incf y lineheight) max-y))
            (return))
          (incf line-num))
        (when (< pos bmod)
          (setf (fr.bmod frec) pos)))
      ;Could continue here: go by buffer lines until hit a buffer line past
      ;zmod.  Actually find last such line.  Then for each such line from bottom
      ;verify it's ok, keep going back...
      (setf (fr.zmod frec) 0))))

(defun frec-grow-linevec (frec)
  ;(frec-arg frec)
  (let* ((linevec (fr.linevec frec))
         (linevec-size (length linevec))
         (ascents (fr.lineascents frec))
         (descents (fr.linedescents frec))
         (lineheights (fr.lineheights frec))
         (linewidths (fr.linewidths frec))
         (new-linevec-size (+ (1+ linevec-size) (ash linevec-size -2)))
         (new-linevec (make-array new-linevec-size))
         (new-ascents (make-array new-linevec-size))
         (new-descents (make-array new-linevec-size))
         (new-lineheights (make-array new-linevec-size))
         (new-linewidths (make-array new-linevec-size)))
    (declare (fixnum linevec-size new-linevec-size))
    (dotimes (i linevec-size)
      (setf (ccl::%svref new-linevec i) (ccl::%svref linevec i)
            (ccl::%svref new-ascents i) (ccl::%svref ascents i)
            (ccl::%svref new-descents i) (ccl::%svref descents i)
            (ccl::%svref new-lineheights i) (ccl::%svref lineheights i)
            (ccl::%svref new-linewidths i) (ccl::%svref linewidths i)))
    (setf (fr.linevec frec) new-linevec
          (fr.lineascents frec) new-ascents
          (fr.linedescents frec) new-descents
          (fr.lineheights frec) new-lineheights
          (fr.linewidths frec) new-linewidths)
    (values new-linevec new-ascents new-descents new-lineheights new-linewidths
            new-linevec-size)))

; List of scripts that erase the entire character block in srcCopy mode.
; Arabic definitely isn't well-behaved.
(defparameter *well-behaved-scripts*
  '(#.#$smRoman))

; Compute sizes of the line that starts at start-pos.
; Return 6 values:
; 1) line length
; 2) ascent
; 3) descent
; 4) lineheight (ascent + descent + leading)
; 5) line width in pixels
;    Will be negative unless all the fonts in the line have the same
;    ascent & descent
; there is no reason for this guy to call snarf-screen-line!
;
; *** Need to call find-script-run here somewhere.
;     This will change the args to styled-line-break, I think.

; the goal of this P.O.S. is to compute the max ascent etc for the line and the width in pixels
;; width only needs to go so far as the visible width

(defun %compute-screen-line (frec start-pos)
  ;(frec-arg frec)
  (with-foreground-rgb
    (let* ((buffer (fr.cursor frec))
           (buffer-size (buffer-size buffer))
           (pos (require-type start-pos 'fixnum))
           (font-limit start-pos)
           (width (%i- (point-h (fr.size frec)) (%i* 2 (fr.margin frec))))
           (hpos 0)
           (new-hpos 0)
           (max-ascent 0)
           (max-descent 0)
           (max-lineheight 0)
           (min-ascent 32768)
           (min-descent 32768)
           (ascent 0)
           (descent 0)
           (leading 0)
           (lineheight 0)
           (maxwid 0)
           (locs (make-array (1+ $max-font-run-length)))
           (chars 0)
           (bytes 0)
           terminator
           ff ms script
           multiple-fonts
           (wrap-p (fr.wrap-p frec))
           (word-wrap-p (fr.word-wrap-p frec))
           (fixed-width-left (and word-wrap-p (ccl::integer->fixed width))))
      (declare (dynamic-extent locs))
      (declare (ignore-if-unused maxwid fixed-width-left locs bytes new-hpos))
      (declare (fixnum pos font-limit width hpos new-hpos chars byte buffer-size
                       ascent descent leading lineheight linewidth
                       max-ascent max-descent max-lineheight min-ascent min-descent))
      (macrolet ((update-maxes ()
                   `(progn
                      (setq lineheight
                            (new-frec-add-leading frec (%i+ ascent descent) leading))
                      (when (> ascent max-ascent) (setq max-ascent ascent))
                      (when (> descent max-descent) (setq max-descent descent))
                      (if (memq script *well-behaved-scripts*)
                        (progn
                          (when (< ascent min-ascent) (setq min-ascent ascent))
                          (when (< descent min-descent) (setq min-descent descent)))
                        (setq min-ascent 0 min-descent 0))
                      (when (> lineheight max-lineheight)
                        (setq max-lineheight lineheight))))
                 (flagged-linewidth (linewidth)
                   `(if (and (not multiple-fonts)(eql max-ascent min-ascent) (eql max-descent min-descent))
                      ,linewidth
                      (- ,linewidth))))
        (%stack-block ((tp $max-font-run-length))
          (loop
            (when (eql pos font-limit)
              (when (eql pos buffer-size)
                (return (values (%i- pos start-pos)
                                max-ascent max-descent max-lineheight
                                (flagged-linewidth hpos))))
              (if ff (setq multiple-fonts t))
              (multiple-value-setq (ff ms) (%set-screen-font buffer pos))
              (setq  script (ff-script ff))
              (setq font-limit (or (buffer-next-font-change buffer pos) buffer-size)))
            (multiple-value-setq (chars bytes terminator)
              (%snarf-buffer-line
               buffer pos tp (%i- font-limit pos) $max-font-run-length))
            (cond ((eql chars 0)
                   (cond ((eql terminator #\tab)
                          (setq hpos (frec-next-tab-stop frec pos hpos))
                          (incf pos)
                          (when (eql max-lineheight 0)
                            (multiple-value-setq (ascent descent maxwid leading) (font-info))
                            (update-maxes))
                          (when (and wrap-p (%i<= width hpos))
                            (return (values (%i- pos start-pos)
                                            max-ascent max-descent max-lineheight
                                            (flagged-linewidth hpos))))
                          
                          (when word-wrap-p
                            (setq fixed-width-left (ccl::integer->fixed (%i- width hpos)))))
                         (t
                          (when (char-eolp terminator)
                            (incf pos))
                          (when (eql max-lineheight 0)
                            (multiple-value-setq (ascent descent maxwid leading) (font-info))
                            (update-maxes))
                          (return (values (%i- pos start-pos)
                                          max-ascent max-descent max-lineheight
                                          (flagged-linewidth hpos))))))
                  ((not wrap-p)
                   (incf hpos (xtext-width tp chars ff ms))
                   (multiple-value-setq (ascent descent maxwid leading)(font-info))
                   (update-maxes)
                   (incf pos chars))
                  ((not word-wrap-p)  ;; here if listener - is wrapped but not word wrapped
                   (let* ((run-width (xtext-width tp chars ff ms))
                          (run-hpos (+ hpos run-width)))
                     (multiple-value-setq (ascent descent maxwid leading)(font-info))
                     (update-maxes)
                     (if (<= run-hpos width)  ;; not right??
                       (progn
                         (incf pos chars)                        
                         (setq hpos run-hpos))
                       ;; now figure out where it wraps
                       (multiple-value-bind (pos-delta hpos-delta) (where-to-wrap (- width hpos) maxwid tp chars ff ms)
                         (return (values (+ pos-delta (%i- pos start-pos))
                                         max-ascent max-descent max-lineheight
                                         (flagged-linewidth (+ hpos hpos-delta))))))))
                  (t                       ; word wrap
                   (let* ((run-width (xtext-width tp chars ff ms))
                          (run-hpos (+ hpos run-width)))
                     (multiple-value-setq (ascent descent maxwid leading)(font-info))
                     (update-maxes)
                     (if (<= run-hpos width)  ;; not right??
                       (progn
                         (incf pos chars)                        
                         (setq hpos run-hpos))
                       ;; now figure out where it wraps
                       (multiple-value-bind (pos-delta hpos-delta) (where-to-word-wrap (- width hpos) maxwid tp chars ff ms)
                         ;(print (list 'returning (- pos start-pos) (+ hpos hpos-delta) pos start-pos chars run-width))
                         (return (values (+ pos-delta (%i- pos start-pos))
                                         max-ascent max-descent max-lineheight
                                         (flagged-linewidth (+ hpos hpos-delta)))))))))))))))

(defun where-to-wrap (space-left maxwid tp chars ff ms)
  (let* (;(font-id (ash ff -16))
         (guess-chars (min chars (truncate space-left maxwid))))
    (cond 
     ((not (plusp guess-chars))(values 0 0))
     (t
      (let* ((guess-width (xtext-width tp guess-chars ff ms))
             (last-width guess-width))
        (cond ((= guess-width space-left)
               (values guess-chars guess-width))
              ((> guess-width space-left)
               (loop
                 (setq guess-chars (1- guess-chars))
                 (if (not (plusp guess-chars))(return (values 0 0)))
                 (setq last-width guess-width)
                 (setq guess-width (xtext-width tp guess-chars ff ms))
                 (when (<= guess-width space-left)
                   (return (values guess-chars guess-width)))))
              (t (loop               
                   (setq guess-chars (1+ guess-chars))
                   (if (> guess-chars chars)(return (values chars last-width)))
                   (setq last-width guess-width)
                   (setq guess-width (xtext-width tp guess-chars ff ms))
                   (if (= guess-width space-left)
                     (return (values guess-chars guess-width))
                     (if (> guess-width space-left)
                       (return (values (1- guess-chars) last-width))))))))))))

;; there are probably more of these
(defvar word-break-char-codes
  (list (char-code #\return)(char-code #\linefeed)(char-code #\space)(char-code #\tab)))

(defun char-code-word-break-p (code) ;; or xwhitespace-or-eol-p
  (memq code word-break-char-codes))

(defun where-to-word-wrap (space-left maxwid tp chars ff ms)
  ;; probably a bug if line starts with word breaks then lotta stuff with none
  ;; look backwards for word breaks - if find one that fits then that's it
  ;; else do just plain wrap
  
  (let ((my-chars chars))
    (prog ()
      again
      (let ((last-word-break
             (dotimes (i my-chars)
               (when (new-char-word-break-p (code-char (%get-word tp (* 2 (- my-chars 1 i)))))
                 (return (- my-chars i))))))  ;; << was (- my-chars i 1)
        (if (and last-word-break (> last-word-break 1))
          ;; do it fit
          (let ((wb-width (xtext-width tp last-word-break ff ms)))
            (if (<=  wb-width space-left)
              (return-from where-to-word-wrap
                (values last-word-break wb-width))
              (progn (setq my-chars (- last-word-break 1))
                     (go again))))
          (return))))
    ;(print 'horse)
    (where-to-wrap space-left maxwid tp chars ff ms)))


; returns a vector of positions in the buffer for starts of
; font runs in the order that they must be drawn on the line.
; buffer is a fred buffer
; the line includes character positions p where start <= p < end
; line-right-p is true if the line direction is right-to-left.
; Doesn't yet handle roman script in non-roman font.
(defun compute-font-run-positions (buffer start end &optional
                                          (line-right-p 
                                           (not (eql 0 (ccl::get-sys-just)))))
  (let ((positions  (or *font-run-positions* (make-array $max-font-changes-per-line)))
        (next start)
        (count 0)
        (end-points nil))
    (declare (fixnum count))
    (when (> end start)
      (setf (aref positions 0) start)
      (incf count)
      (let ((len (length positions)))
        (declare (fixnum len))
        (loop
          (setq next (buffer-next-font-change buffer next))
          (when (or (null next) (>= next end))
            (return))
          (when (>= count len)
            (let ((new (make-array (the fixnum (+ len len)))))
              (dotimes (i len)
                (setf (aref new i)(aref positions i)))
              (setq len (+ len len))
              (setq positions new)
              (when *font-run-positions* (setq *font-run-positions* positions))))
          (setf (aref positions count) next)
          (incf count)))
      (let* ((ordering (or *font-run-ordering* (make-array count)))
             (dir-function #'(lambda (i)
                               ; (format t "~&(dir-function ~d)~%" i)
                               (let* ((pos (aref positions i))
                                      (font-num (point-v
                                                 (ccl::buffer-char-font-codes
                                                  buffer pos)))
                                      (script (ccl::font-2-script font-num)))
                                 (not
                                  (eql 0 (ccl::get-script
                                          script #$smScriptRight)))))))
        (declare (fixnum count)
                 (dynamic-extent dir-function))
        (when (> count (length ordering))
          (setq ordering
                (setq *font-run-ordering*
                      (make-array count))))
        (setq end-points *font-run-endpoints*)
        (when (or (null end-points) (> count (length end-points)))
          (setq end-points
                (setq *font-run-endpoints*
                      (make-array count))))
        (ccl::get-format-order 0 count line-right-p dir-function ordering)
        (dotimes (i count)
          (let ((ordering-i (aref ordering i))
                (count-1 (1- count)))
            (setf (aref end-points i)
                  (if (eql ordering-i count-1)
                    end
                    (aref positions (1+ ordering-i)))
                  (aref ordering i) (aref positions ordering-i))))
        (dotimes (i count)
          (setf (aref positions i) (aref ordering i)))))
    (values positions end-points count)))

; Returns four values describing the script runs between
; start <= pos < end in buffer.
; 1) positions  - array of starting positions
; 2) end-points - array of ending positions
; 3) scripts    - array of script numbers
; 4) count        the number of runs
; The runs are returned in the same order that they must be drawn.
; this is interesting and not called
(defun compute-script-run-positions (buffer start end &optional
                                            (line-right-p 
                                             (not (eql 0 (ccl::get-sys-just)))))
  (multiple-value-bind (positions end-points count)
                       (compute-font-run-positions buffer start end line-right-p)
    (declare (fixnum count))
    (let ((scripts (or *font-run-ordering* (make-array count))))
      (unless (eql count 0)
        (let* ((pos (aref positions 0))
               (end-pos (aref end-points 0))
               (script (ff-script (ccl::buffer-char-font-codes buffer pos)))
               (i 1)
               (out-i 0)
               next-pos next-end-pos next-script)
          (setf (aref scripts out-i) script)
          (loop
            (when (>= i count) (return))
            (setq next-pos (aref positions i)
                  next-end-pos (aref end-points i)
                  next-script (ff-script (ccl::buffer-char-font-codes buffer next-pos)))
            (if (eql next-script script)
              (if (< next-pos pos)
                (setf (aref positions out-i) (setq pos next-pos))
                (setf (aref end-points out-i) (setq end-pos next-end-pos)))
              (setf pos next-pos
                    end-pos next-end-pos
                    script next-script
                    out-i (1+ out-i)
                    (aref positions out-i) pos
                    (aref end-points out-i) end-pos
                    (aref scripts out-i) script))
            (incf i))
          (setq count (1+ out-i))))
      (values positions end-points scripts count))))

(defun %screen-line-hpos (frec start-pos end-pos &optional (line-end end-pos) script
                               (line-num (frec-screen-line-num frec start-pos)))
  (multiple-value-bind (left-margin right-margin) (frec-margins frec start-pos)
    (let ((width (%screen-line-width frec start-pos end-pos line-end script))
          (hscroll (fr.hscroll frec))
          (left (if line-num
                  (screen-line-ends frec start-pos line-num (%i- right-margin left-margin))
                  0)))
      (%i+ width left (%i- left-margin hscroll)))))

;Assumes no line breaks between start-pos and end-pos
;Returns two values:
;1) The screen position of end-pos in the current keyboard script
;2) An alternative position in another script, or NIL if there is none.

(defun %screen-line-width (frec start-pos end-pos &optional 
                                (line-end end-pos)
                                script)
  (declare (fixnum start-pos end-pos))
  #-bccl (frec-arg frec)
  (%stack-block ((tp $max-font-run-length))
    (let ((buffer (fr.cursor frec))
          (pos start-pos)
          (font-limit start-pos)
          (hpos 0)
          (len 0)
          (bytes 0)
          (font-index 0)
          run-pos ff ms
          initial-pos initial-ff recorded?)
      (declare (fixnum pos font-limit hpos len bytes chars))
      (when (or (eql start-pos end-pos)
                (%i<= line-end 0)
                (and (eql end-pos line-end)  ; << added this clause 7/3/96
                     (char-eolp (buffer-char buffer (1- line-end)))))
        (return-from %screen-line-width 0))
      (when (and ;(%i> line-end 0)
                 (char-eolp (buffer-char buffer (1- line-end))))
        (decf line-end))
      (when (%i<= line-end start-pos)
        ;(when (and (> (ccl::buffer-size buffer) 0)
                   (return-from %screen-line-width 0))
      (with-font-run-vectors
        (with-foreground-rgb
          (multiple-value-bind (font-starts font-ends font-count)
                               (compute-font-run-positions
                                buffer start-pos line-end (fr.line-right-p frec))
            (flet ((record-position (pos)
                     (if (not initial-pos)
                       (setq initial-pos pos
                             initial-ff ff)
                       (return-from %screen-line-width
                         (if (eql pos initial-pos)
                           pos
                           (let ((keyscript (or script (fr.keyscript frec)))  ; WHAT?
                                 (initial-script (ff-script initial-ff)))
                             (if (eql initial-script keyscript)
                               (values initial-pos pos)
                               (values pos initial-pos))))))))
              (loop
                (when (eql pos font-limit)
                  (when (eql font-index font-count)
                    (if initial-pos
                      (return initial-pos)
                      (error "Should have returned already. Start pos ~S end pos ~s"
                             start-pos end-pos)))
                  (setq pos (aref font-starts font-index)
                        font-limit (aref font-ends font-index))
                  (incf font-index)
                  (multiple-value-setq (ff ms) (%set-screen-font buffer pos)))
                (multiple-value-setq (len bytes)
                  (%snarf-buffer-line buffer pos tp (%i- font-limit pos) $max-font-run-length))
                (setq recorded? nil)
                (cond ((eql 0 len)
                       (setq run-pos (- end-pos pos))
                       (setq hpos (frec-next-tab-stop frec pos hpos))
                       (incf pos)
                       (when (eql pos end-pos)
                         (setq recorded? t)
                         (record-position hpos)))
                      ((and (%i<= 0 (setq run-pos (- end-pos pos)))
                            (%i<= run-pos len)
                            (or (ff-left-to-right-p ff)
                                (and (not (eql run-pos 0))
                                     (if (eql run-pos len)
                                       (progn 
                                         (setq recorded? t)
                                         (record-position hpos)
                                         nil)
                                       t))))
                       (setq recorded? t)
                       (let ()
                         (record-position (%i+ hpos (xtext-width tp run-pos ff ms)))))) ;(ccl::char-2-pixel tp byte-pos :hilite ;; ???
                                                                                  ;:end bytes))))))
                (unless (eql 0 len)
                  (incf hpos (xText-Width tp len ff ms))
                  (incf pos len))
                (unless recorded?
                  (when (eql run-pos 0)
                    (record-position hpos)))))))))))

;; keke's version ??
#+ignore
(defun %screen-line-width2 (frec start-pos end-pos &optional 
                                (line-end end-pos)
                                script)
  (declare (fixnum start-pos end-pos)
           (ignore script))
  (let ((buffer (fr.cursor frec)))
    (when (or
           ;; bidi means width can be greater than 0 even if start==end.
           ; (eql start-pos end-pos)
           (%i<= line-end 0)
           (and (not (zerop line-end))
                (eql end-pos line-end)  ; << added this clause 7/3/96
                (char-eolp (buffer-char buffer (1- line-end)))))
      (return-from %screen-line-width 0))
    ;; was ignored before why?
    (when (char-eolp (buffer-char buffer (1- line-end)))
      (decf line-end))
    (when (%i<= line-end start-pos)
      (return-from %screen-line-width 0))
    ;; 2004-12-26 what was the purpose of with-font-run-vectors?
    (with-font-run-vectors
      (with-foreground-rgb              ; required?
        (let* ((layout (frec-atsu-layout frec))  ;; we don't want to do this ???
               (atsu-buffer (layout-text-buffer layout))
               (epos (1- end-pos))
               (code 0)
               (len 0))
          (declare (fixnum epos code len))
          ;; Check if we are in a bidirectional/right-to-left line
          ;; Note that even if start-pos == end-pos == 0, that does not mean the char
          ;; is at the leftmost position in a line if the line has right-to-left direction.
          (if (or (and (eql start-pos end-pos)
                       ;; end-pos==0 means char is at the start of line [buffer].
                       ;; char[end-pos-1] == newline means char is at the start of line.
                       (or (zerop end-pos)
                           (char-eolp  (buffer-char buffer (1- end-pos))))
                       (eq (bidi-type-category (char-code (buffer-char buffer end-pos)))
                           :strong-R))
                  (dotimes (i (- end-pos start-pos) nil)
                    (declare (fixnum i))
                    (setq code (char-code (buffer-char buffer epos)))
                    (cond
                     ((eq (bidi-type-category code) :strong-r)
                      (return t))
                     ((member (bidi-type-category code) '(:weak :neutral)))
                     (t (return nil)))
                    (decf epos)))
            (let (char 
                  temp-buffer
                  use-temp-buffer-p
                  (bidi-type :strong)
                  (code 0)
                  ; (tab-count 0)
                  )
              (declare (fixnum code))
              (setq epos end-pos)
              ;; 2005-01-17 19:03:11
              ;; what does this loop do?
              ;; 1. Fetch char at epos
              ;; 2. If char is newline--epos at EOL, return
              ;;    Otherwise examine the bidi type of the char
              ;; 3. If :strong-R, advance the epos forward
              ;;    If :neutral, advance the epos forward
              ;;    If neither, return.
              (loop
                (setq char (buffer-char buffer epos)
                      code (char-code char))
                ;; 2004-12-26 tab handling is not implemented yet.
                ;;
                ;; needs to check the presense of #\tab. If so,
                ;; call %snarf-buffer-line multiple times and ..
                ;; if tab is present, use text-width instead and...
                ;;
                ;; aaaaaaa->  bbbbbbb
                ;; |<--->|tab |<--->|
                ;;   |           \
                ;;   |            *- offset-to-pixel
                ;; text-width
                ;;
                ;; * fetch 'aaaaaaa' and measure with text-width
                ;; * measure tab-width
                ;; * fetch 'bbbbbbb' and measure with offset-to-pixel
                ;;
                (if (or (eq char #\null) (char-eolp char))
                  (return)
                  (case (bidi-type-category code)
                    ((:strong-r) 
                     (setq bidi-type :strong
                           epos (1+ epos)))
                    ((:weak :neutral)
                     (setq bidi-type :weak
                           epos (1+ epos)))
                    (t (return)))))
              (if (< $max-font-run-length (- epos start-pos))
                (setq temp-buffer (#_newptr (* (- epos start-pos) 2))
                      use-temp-buffer-p t)
                (setq temp-buffer atsu-buffer))
              (unwind-protect
                (progn
                  (setq len (%snarf-buffer-line2 buffer start-pos temp-buffer
                                                 (- epos start-pos) 
                                                 (if use-temp-buffer-p
                                                   (- epos start-pos)
                                                   $max-font-run-length)))
                  ;; FIXIT
                  (when (zerop len)
                    (return-from %screen-line-width 0))
                  ;; what ??
                  (ats:set-layout-text-ptr layout temp-buffer len 0 len)
                  (multiple-value-bind (font-starts font-ends font-count)
                                       (compute-font-run-positions
                                        buffer start-pos line-end (fr.line-right-p frec))
                    (dotimes (i font-count)
                      (declare (fixnum i))
                      (let ((start (aref font-starts i))
                            (end (aref font-ends i)))
                        (declare (fixnum start end))
                        (when (<= start-pos start epos)
                          (multiple-value-bind (ff ms)
                                               (buffer-char-font-codes buffer start)
                            (ats:set-layout-run-style layout
                                                      (find-atsu-style ff ms)
                                                      (- start start-pos)
                                                      (- (min end epos) start)))))))
                  (multiple-value-bind (h1 h2)
                                       (ats:layout-offset-to-pixel layout (- end-pos start-pos))
                    (if (and (eq bidi-type :strong)
                             h2)
                      h2              ; should return 2 values? FIXIT
                      h1)))
                (when use-temp-buffer-p
                  (ats:set-layout-text-ptr layout atsu-buffer 0)
                  (#_disposeptr temp-buffer))))
            (let ((width 0)
                  (max (- end-pos start-pos))
                  (spos start-pos)
                  (chars-read 0))
              (declare (fixnum width max spos))
              (loop
                (when (= spos end-pos)
                  (return width))
                (setq len (%snarf-buffer-line buffer spos atsu-buffer (- end-pos spos) $max-font-run-length))
                (%atsu-text-inserted layout len)
                (unless (zerop len)
                  (multiple-value-bind (font-starts font-ends font-count)
                                       (compute-font-run-positions
                                        buffer spos (+ spos len) (fr.line-right-p frec))
                    #+ignore
                    (format t "stants: ~a, ends: ~a, count: ~a~%" 
                            font-starts font-ends font-count)
                    ; ((0 26) (26 27))
                    ; start-pos: 0 end-pos: 27 line-end: 29
                    (dotimes (i font-count)
                      (declare (fixnum i))
                      (let ((start (aref font-starts i))
                            (end (aref font-ends i)))
                        (declare (fixnum start end))
                        (when (<= start-pos start end-pos)
                          (multiple-value-bind (ff ms)
                                               (buffer-char-font-codes buffer start)
                            (ats:set-layout-run-style layout 
                                                      (find-atsu-style ff ms)
                                                      (- start spos)
                                                      (- (min end (+ spos len)) start)))))))
                  (incf width (ats:text-width layout 0 len)))
                (incf chars-read len)
                (if (<= max chars-read)
                  (return width)
                  (progn
                    (incf spos len)
                    (setq width (frec-next-tab-stop frec spos width))
                    (incf spos 1)
                    (incf chars-read 1)))))))))))

(Defun x%buffer-bytes->chars  (mark start bytes)
  (declare (ignore mark start))
  (ash bytes -1))



; Return the horizontal position in pixels for the next tab stop.
; pos is the position of the tab character in the buffer
; hpos is the horizontal position of the beginning of the tab character in pixels
; measured from the margin.
; Currently, tabs are put every (* 36 (/ fr.tabcount 8)) pixels, e.g. at the
; default value of 8, there is a tab every 36 pixels = 1/2 inch.
; Eventually, we'll allow a sequence for buffer-wide tab stops and
; include rulers for tab stop setting for a region of the buffer (hence the POS arg).
; Probably, 72 pixels/inch shouldn't be hard-coded in this way.
#| ; dont tell people its chars and then do pixels
(defun frec-next-tab-stop (frec pos hpos)
  (declare (ignore pos))
  (frec-arg frec)
  (let* ((36*tabcount (* (fr.tabcount frec) 36))
         (tabs (1+ (floor (* hpos 8) 36*tabcount))))
    (round (* tabs 36*tabcount) 8)))
|#
(defun frec-next-tab-stop (frec pos hpos)
  (frec-arg frec)
  (let ((tabcount (fr.tabcount frec)))
    (multiple-value-bind (ff ms)(buffer-char-font-codes (fr.buffer frec) pos)
      (let* ((len (* tabcount (font-codes-string-width " " ff ms)))
             (delta (nth-value 1 (truncate hpos len))))
        (+ hpos (- len delta))))))
      
      

; Return the justification at POS.
; Will be one of :left, :right, :center
(defun frec-justification (frec &optional pos)
  (declare (ignore pos))
  (frec-arg frec)
  (cond ((fr.center-justified-p frec)
         :center)
        ((fr.right-justified-p frec)
         :right)
        (t :left)))

(defun %set-frec-justification (frec justification)
  (frec-arg frec)
  (setf (buffer-justification (fr.cursor frec)) justification)
  (case justification
    ((:left nil)
     
     (setf (fr.center-justified-p frec) nil
           (fr.right-justified-p frec) nil))
    (:center
     (setf (fr.center-justified-p frec) t
           (fr.right-justified-p frec) nil))

    (:right
     (setf (fr.center-justified-p frec) nil
           (fr.right-justified-p frec) t))))

; Return two values, the left & right margins, in pixels
(defun frec-margins (frec &optional pos)
  (declare (ignore pos))
  ;(frec-arg frec)
  (let ((margin (fr.margin frec)))
    (values margin (- (point-h (fr.size frec)) margin))))

(defun %set-screen-font (buffer position)
  (multiple-value-bind (ff ms) (ccl::buffer-char-font-codes buffer position)    
    (setq ms (make-point (point-h ms) #$srcOr))    
    (progn 
      (#_textfont (ash ff -16))
      (#_textface (logand (ash ff -8) #xff))
      (#_textmode (ash ms -16))
      (#_textsize (logand ms #xffff)))
    (set-grafport-fred-color (logand 255 ff))
    (values ff ms))) 

(defvar my-frec nil) ; temp -  dont say f

(defun %update-screen-lines (frec old-linevec old-ascents old-descents
                                  old-lineheights old-linewidths &optional total-height)
  (declare (ccl::resident))             ; Just 'cuz it's big. Thats an understatement.
  ;(frec-arg frec)
  (macrolet ((maybe-grow-linevec (index)
               ; in case you hadn't guessed, this expects the lexical environment
               ; set up by the PROG* below. This definition is here so
               ; that we can GO to tags in the PROG*
               `(when (>= ,index linevec-length)
                  (multiple-value-setq
                    (linevec ascents descents lineheights linewidths linevec-length)
                    (frec-grow-linevec frec))))
             (set-linevecs (linevecs index values)
               `(progn
                  (maybe-grow-linevec ,index)
                  ,@(mapcar #'(lambda (vec val) `(setf (linevec-ref ,vec ,index) ,val))
                            linevecs values))))
    (prog* ((buffer (fr.cursor frec))
            ;(*frdebug* t)
            (buffer-size (buffer-size buffer))
            (bmod (fr.bmod frec))
            (bmod-line-pos nil)
            (zmod (let ((zmod (fr.zmod frec)))  ;; <<
                    (declare (fixnum zmod))
                    (if (eql zmod #xFFFFFF) -1 (- buffer-size zmod))))
            ;(orig-zmod zmod)
            (bwin (fr.bwin frec))
            (zwin (max 0 (- buffer-size (fr.zwin frec))))  ; sleazy - fr.zwin can be wrong
            (truezwin (fr.truezwin frec))
            (wpos (buffer-position (fr.wposm frec)))
            (word-wrap-p (fr.word-wrap-p frec))
            (new-bwin nil)
            (new-zwin nil)
            (new-zwin-return-p nil)
            (linevec (fr.linevec frec))
            (ascents (fr.lineascents frec))
            (descents (fr.linedescents frec))
            (lineheights (fr.lineheights frec))
            (linewidths (fr.linewidths frec))
            (linevec-length (length linevec))
            (numlines (fr.numlines frec))
            (display-height (point-v (fr.size frec)))
            (vpos 0)
            (bmod-line 0)
            ;(bwin-line)
            (zmod-line numlines)
            (new-bmod-line 0)
            new-bwin-line new-zwin-line new-zmod-line
            (new-lines 0)
            middle-pos pos
            line ascent descent lineheight linewidth
            (old-bwin-vpos 0)
            old-zmod-vpos
            bwin-vpos bmod-vpos zmod-vpos zwin-vpos
            new-bottom-pos new-bottom-line new-bottom-vpos
            (num-whole-lines numlines)
            my-zwin
            new-bwin-old-line
            bottom-only)
      (declare (fixnum buffer-size bmod zmod bwin zwin wpos
                       numlines display-height vpos bmod-line zmod-line
                       new-bmod-line new-lines))

      ;bmod is the distance in chars from the beginning of the buffer to first modification
      ;  or #xffffff if no mod
      ;zmod is the distance in chars from the end of modification to end of b uffer
      ; or -1 if no mod - we change it to pos of last modified char (or 1 past?)
      ; numlines is the number of lines currently visible on the screen ("abc" #\newline is 2 lines)
      ; bwin is the first char of first line visible
      ; zwin is the last char visible
      ; new-bwin is new first char of first line visible after scrolling?
      ; wpos is pos of xx-display-start-mark (which is > new-bwin if h-scrolled, else =)
      ; (%redraw-screen-lines frec new-bwin 0 (1- new-bwin-line)) ; top from new-bwin, line 0 -new stuff scrolling in
      ; (%redraw-screen-lines frec bmod-line-pos new-bmod-line new-zmod-line)
      ; mid from start of bmod line
      ; (%redraw-screen-lines frec zwin new-zwin-line (1- new-lines) zwin-vpos) ; from zwin
      ; top - if not scrolling -nothing to do
      ;       if scrolling up - do it
      ;       if scrolling down - there is some new stuff to draw & some stuff to scroll
      ; middle - draw the new stuff - possibly including entire first line if height changes (or  script)
      ;              or if it contains any italic stuff near first changed char
      ;               probably draw the entire last line too but only if > 1 line.
      ; bottom - if zmod is end of buffer - erase to end of screen
      ;          if not
      ;          how much bottom moved is function of delta mod plus scrolling
      ;          scroll some and possiby draw some new stuff if effectively scrolled up
      ; the current model pushes some of my notion of bottom into middle
      ; We're going to split up the screen into 5 areas which are handled
      ; by the code below as top, middle, and bottom.
      ;
      ;Top
      ; 1) new-bwin to bwin  - if new-bwin > bwin, nothing to do
      ;      new-bwin-line
      ; 2) bwin to bmod
      ;      old-bwin-vpos, bwin-vpos, bmod-vpos
      ;Middle
      ; 3) bmod to zmod
      ;      new-bmod-line, new-zmod-line
      ; 4) zmod to zwin
      ;      old-zmod-vpos, zmod-vpos, zwin-vpos
      ;Bottom
      ; 5) zwin to new-zwin
      ;      new-zwin-line, new-lines
      ;
      ; The bwin to bmod and zmod to zwin areas can be scrolled to their new
      ; positions (after bmod & zmod are possibly moved up due to line-wrap)
      ; new-bwin used to be nil sometimes
      ;
      ; its a good idea to avoid compute-screen-line when wrapped. 3/26/95
      (when (and total-height (> total-height display-height))
        (setq num-whole-lines (1- numlines)))
      (when (and (neq bmod #xffffff)    ; whole when 5/23 - an easy fix for once
                 (neq zmod buffer-size)
                 (fr.wrap-p frec))
        ; when wrapped all bets are off till next newline or zmod whichever comes later
        (let ((line-pos (buffer-forward-find-eol buffer  zmod))) ; was bmod - bad
          (setq zmod (max zmod (or line-pos buffer-size))))
        (WHEN (AND (EQ FREC PARA-FREC) (< BMOD PARA-END))
          (SETQ PARA-FREC NIL)))
      ; my-zwin is what we can trust in old linevec
      (setq my-zwin (if (or (eq bmod #xffffff)(and (<= zmod zwin)(<= zmod truezwin)))
                      zwin  ; trust zmod to zwin
                      (if (> bmod truezwin)
                        truezwin  ; trust to truezwin
                        bmod)))   ; trust to bmod
      ;(when (neq zwin my-zwin)(push (list zwin truezwin my-zwin) stuff))
      (cond ((and (eql wpos bwin)(> bmod wpos))  ; added > bmod 5/12- > vs >= 1/10/96
             (setq new-bwin bwin)
             (when (neq numlines 0)(setq new-bwin-old-line 0)))
            ((or (eq numlines 0)
                 (< wpos bwin)
                 (>= wpos my-zwin)  ; was zwin
                 (<= bmod wpos))
             (setq new-bwin (or
                             (and (<= zmod bmod)
                                  (%frec-screen-line-start frec wpos))
                             (%compute-screen-line-start frec wpos))))
            (t (when (> wpos bwin)   ; top may scroll up - partial bottom line?
                 (let ((pos bwin))
                   (setq old-bwin-vpos 0)
                   (dotimes (i numlines)
                     (when (>= pos bmod)(return))
                     (when (>= pos wpos)
                       (setq bwin-vpos 0)
                       (setq new-bwin pos)
                       (setq new-bwin-old-line i)
                       (return))
                     (incf old-bwin-vpos (linevec-ref old-lineheights i))
                     (incf pos (linevec-ref old-linevec i)))))
               (when (not new-bwin)
                 (setq new-bwin (or
                                 (and (<= zmod bmod)
                                      (%frec-screen-line-start frec wpos))
                                 (%compute-screen-line-start frec wpos))))))
      (dbmsg "~&UPDATE-LINES, numlines=~S bmod=~S bwin=~S wpos=~S zmod=~Szwin=~S truezwin ~s"
               numlines bmod bwin wpos zmod zwin truezwin)
      (setf (fr.changed-p frec) t)
      ; below happens when we have just created  the frec, or the buffer is
      ; empty, or we previously scrolled  past the bottom.
      (when (or (eql 0 numlines)
                (and (<= bmod bwin)(>= zmod zwin))  ; added 5/12
                (and (eql 1 numlines)
                     (eq 0 (linevec-ref linevec 0)))
                (>= new-bwin my-zwin))
        #|
                (let ((old-last-char bwin))  ; was > new-bwin zwin or something
                  (dotimes (i numlines)    ; not exactly right friday if bmod between old and new bwin
                    (incf old-last-char (linevec-ref old-linevec i)))

                  (>= new-bwin old-last-char)))|#  ; no old stuff. All is bottom - i.e. nothing was visible
        (setq new-zwin new-bwin)  ; maybe wrong  ; << wednesday wierdness
        (setq new-bottom-pos new-bwin
              new-bottom-line 0
              new-bottom-vpos 0)
        (setq numlines 0
              new-lines 0)
        (setq my-zwin new-bwin)  ; huh? was zwin
        (setq bmod 0 zmod 0)
        (setq  bottom-only t)
        (go NEW-BOTTOM))

      (dbtest (or (eq bmod #xFFFFFF) (<= bmod zmod)))
      (when (<= bmod bwin)    ; is beginning of change before or at what we now see?
        (setq bmod new-bwin       ; if so set beginning of change to start of what we want to see - hmm
                               ; at least this means that no before stuff needs to be scrolled or drawn
              middle-pos bmod); dunno bout middle-pos
        (dbmsg "~&  No TOP. bmod=0")
        (go MIDDLE))

      ;Compute top region  - here if  maybe some before stuff needs to be scrolled and/or drawn
      (when (< wpos bwin)    ; scrolling down?

        (dbmsg "~& TOP Scroll down, new-bwin=~S" new-bwin)
        (setq pos new-bwin)             ; compute new-bwin:bwin
        (loop
          (multiple-value-setq (line ascent descent lineheight linewidth)
            (%compute-screen-line frec pos))
          (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                        (line ascent descent lineheight linewidth))
          (incf new-lines)
          (incf pos line)
          (incf vpos lineheight)
          (dbtest (<= pos bwin))
          (when (>= vpos display-height) ; make believe its bottom
            (setq new-bottom-pos new-bwin
                  new-bottom-line 0
                  new-bottom-vpos 0
                  new-zwin pos)
            (dbmsg " -> all the way") ; this case used to fail
            (go DRAW-IT))
          (when (>= pos bwin)
            (loop ; i removed this once - that cant be right???
              (when (or (<= pos bwin) (>= bmod-line numlines))
                (return))
              (incf bwin (linevec-ref old-linevec bmod-line))
              (incf old-bwin-vpos (linevec-ref old-lineheights bmod-line))
              (incf bmod-line))
            (return))))
        ;(dbmsg " new-lines=~S" new-lines))

      (dbmsg "~&  Compute Bwin:Bmod")
      ; did we check for nothing before bmod-line? - else these vec refs will puke
      ; here we can avoid some work if top not moving

      (let ((nextpos (if (or new-bwin-old-line (> new-bwin bwin)) new-bwin bwin)))   ; changed 5/17
        ; (declare (fixnum nextpos vpos-inc))
        (setq bwin-vpos vpos
              bmod-vpos vpos  ; ???
              new-bwin-line new-lines)
        (when (and (not (eql bmod #xffffff))(> bmod new-bwin)) ; ??? Sunday
          (block frob
            (when (> new-bwin bwin) ; this piece only happens if scrolling & modified - is broke
              (if new-bwin-old-line
                (setq bmod-line new-bwin-old-line)
                (let ((pos bwin))
                  ; find bmod-line = index of new-bwin in old line-vec
                  (loop
                    (when (>= bmod-line numlines)
                      (return-from frob))
                    (incf pos (linevec-ref old-linevec bmod-line))
                    (incf bmod-line)
                    (when (>= pos new-bwin)
                      ;(push (list 'returning new-bwin bmod-line numlines) memo)
                      (return))
                    ))))
            (loop
              ; line is old  # chars on bmod-line. bmod-line is initially 0 - gets inc'd
              (when (>= bmod-line numlines)
                (SETQ new-bmod-line new-lines) ; friday - happens if bmod past visible region 0r new-bwin
                (setq bmod-vpos vpos)  ; added 5/8
                (return-from frob))
              (setq line (linevec-ref old-linevec bmod-line)
                    ascent (linevec-ref old-ascents bmod-line)
                    descent (linevec-ref old-descents bmod-line)
                    lineheight (linevec-ref old-lineheights bmod-line)
                    linewidth (linevec-ref old-linewidths bmod-line))
              (setq pos nextpos
                    nextpos (+ pos line))
              (dbmsg "~&bmod ~s nextpos ~s vpos ~s" bmod nextpos vpos)
              (when (<= bmod nextpos)    ; was < - change seems to avoid bad case - like this better
                (when (and word-wrap-p (> bmod-line 0))
                  (let* ((old-len (linevec-ref old-linevec (1- bmod-line)))
                         (prev-pos (- pos old-len))
                         (new-len (%compute-screen-line frec prev-pos)))
                    (unless (eql old-len new-len) ; seems to work - dont understand
                      (decf bmod-line)
                      (setq bmod pos
                            pos prev-pos)
                      (decf vpos (linevec-ref old-lineheights bmod-line))
                      (decf new-lines))))
                ; recompute this line
                (cond ((and (= bmod nextpos)
                            (or (eq 0 nextpos)
                                (char-eolp (buffer-char (fr.buffer frec) (1- NEXTPOS)) )))
                       ; at line beginning - no fancy stuff
                       (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                                     (line ascent descent lineheight linewidth))
                       (incf vpos lineheight)
                       (incf new-lines)
                       (incf bmod-line)
                       (setq middle-pos bmod)
                       (setq bmod-line-pos middle-pos
                             new-bmod-line new-lines
                             bmod-vpos vpos))
                      (t
                       (let ((old-height lineheight))
                         (multiple-value-setq (line ascent descent lineheight linewidth)
                           (%compute-screen-line frec pos))

                         (dbmsg "~&recomputing line ~s pos ~S len ~S" new-lines pos line)
                         (if (or (not  (eql  old-height lineheight))
                                 (fr.right-justified-p frec)  ; 6/10/95
                                 (fr.center-justified-p frec)
                                 ; negative width says varying heights on line - not really necessary to
                                 ; back up but new-clear-screen-line wont tell us screen pos in that case
                                 (<= linewidth  0))
                           (progn (setq bmod pos))
                           (when (<= bmod nextpos)  ; was < 5/19
                             (let ((foo (line-redraw-pos frec pos bmod))) ;  italic or not well  behaved
                               (when foo (setq bmod foo)))))
                         (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                                       (line ascent descent lineheight linewidth))
                         (setq middle-pos (+ pos line))
                         (incf vpos lineheight)
                         (dbmsg "~&   gotta new vpos ~s ~s ~s" vpos bmod nextpos)
                         (incf new-lines)
                         (setq bmod-line-pos pos
                               new-bmod-line (1- new-lines)
                               bmod-vpos (- vpos lineheight))
                         )))
                (when (and (<= zmod middle-pos))  ; this may be silly now
                  (setq new-zmod-line new-bmod-line))
                (return))
              (incf bmod-line)
              (when (not (eql bwin new-bwin))
                (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                              (line ascent descent lineheight linewidth)))

              (incf vpos lineheight)
              (incf new-lines)
              ))))
      (when (eql 0 new-lines)  ; different now??
        (setq bmod-line 0 bwin-vpos nil middle-pos new-bwin bmod-line-pos new-bwin))

      MIDDLE
      (dbmsg "~&Top measured, bwin=~S wpos=~S bmod=~S bmod-line=~S new-lines=~S middle-pos=~s zmod=~s vpos=~S"
             bwin wpos bmod bmod-line new-lines middle-pos zmod vpos)
      ; looking for bottom stuff to scroll - between zmod and old numlines
      ;(setq new-bmod-line new-lines)

      (unless  (eql bmod-line numlines)
        (when middle-pos
          (when (and (< zmod middle-pos))  ; what if zmod is -1???
            (dbmsg "~& setting zmod to middle-pos ~s was ~s" middle-pos zmod)
            (setq zmod middle-pos)))
        (when (fr.zwin-return-p frec) (incf zwin))
        (when (and (< zmod my-zwin) (< wpos my-zwin)) ; zmod -1 ??
          (let ((zmod-line-end (if (or (fr.wrap-p frec)(eq bmod #xffffff); if wrap, done already
                                       (eql zmod buffer-size)  ; added 5/27
                                       (and middle-pos (eql zmod middle-pos))) ; also done already - added 5/27
                                 zmod
                                 (or (buffer-forward-find-eol buffer zmod)
                                     zmod)))) ; 5/25 + refs
            ; Get start of first unmodified line in zwin, zwin-line
            (loop
              (decf zmod-line)
              ; zmod-line initially numlines previously visible - beware of 0
              (setq new-zwin (- my-zwin (linevec-ref old-linevec zmod-line)))
              (when (<= new-zwin zmod-line-end)
                (dbmsg "~& sooner my-zwin = ~s zwin= ~s truezwin= ~s new-zwin= ~s zmod-line= ~s zmod-line-end ~s"
                     my-zwin zwin truezwin new-zwin zmod-line zmod-line-end)
                (if (eql new-zwin zmod-line-end)
                  (progn
                    ;was here my-zwin = 723 zwin= 790 truezwin= 772 new-zwin= 721
                    (dbmsg "~& was here my-zwin = ~s zwin= ~s truezwin= ~s new-zwin= ~s"
                           my-zwin zwin truezwin new-zwin)
                    (setq my-zwin new-zwin))
                  (incf zmod-line))
                (return))
              (when (<= new-zwin wpos)
                (if (eql new-zwin wpos)
                  (setq my-zwin new-zwin)
                  (incf zmod-line))
                (setq middle-pos wpos zmod wpos)
                (return))
              (setq my-zwin new-zwin)
              ; I don't think this is possible, but be safe.
              (when (eql zmod-line bmod-line)
                ; it happens when bmod = zmod - which happens when checking files with new flavored comments
                ;(cerror "continue" "(eql zmod-line bmod-line)")
                (setq zmod my-zwin)
                (return))))))
;      (print-db zwin buffer-size zmod-line bmod-line numlines)
      (dbmsg "~&  zmod-line=~S new-bwin=~S" zmod-line new-bwin)
      ; Do bmod:zmod
      (dbmsg "~&bmod:zmod new-bmod-line ~s new-zmod-line ~s vpos ~s middle-pos ~s bmod ~s zmod ~s zwin ~s"
              new-bmod-line new-zmod-line vpos middle-pos bmod zmod zwin)

      (when (and middle-pos (neq bmod #xffffff))
      (let ((pos middle-pos) line)  ; whats this line business?

        (when (>= zmod middle-pos)
          (when (not new-zmod-line)
            (setq new-zmod-line bmod-line))
          (loop
            (when (and (>= pos zmod)(eql zmod buffer-size)) ; 3/23
              (DBMSG "~&DONE to zmod ~s pos ~s" zmod pos)
              (setq new-zwin-line new-lines)
              (setq new-zmod-line new-lines)
              (setq new-zwin pos)
              (go DRAW-it))
            ; this fixes scrolling case and messes up normal stuff
            ; scrolling case computes lines past zmod here and again in new-bottom or something
            ; maybe comparing bmod-line fixes it - well half way
            (when (and (> pos zmod)(not (eql bmod-line zmod-line))) ; 5/13 ; this may be messing up
              (setq new-zwin-line new-lines)
              (setq new-zmod-line new-lines)
              (setq new-zwin pos)
              (return))
            (when (>= pos my-zwin) ; dont get this bit
              (loop  ;?
                (when (or (<= pos my-zwin) (>= zmod-line numlines))
                  ; pos cant be less first time can only be =
                  (DBMSG "~&HUH POS ~S ZWIN ~S new-lines ~s" POS ZWIN new-lines)
                  (setq new-zwin pos)  ;?? 3/23
                  (return))
                ; now inc my-zwin so pos can be less
                (incf my-zwin (linevec-ref old-linevec zmod-line))
                (incf zmod-line))
              (when (and (>= pos zmod) (eql pos my-zwin))
                (setq new-zwin pos)
                (return)))
            (multiple-value-setq (line ascent descent lineheight linewidth)
              (%compute-screen-line frec pos))
            (when (eql line 0)  ; ? what? on earth is this????
              (dbmsg "~&EEK pos ~s new-lines ~s " pos new-lines)
              (setq zmod-line numlines)
              (setq new-zwin pos)
              (return))

            (dbmsg "~&setting from pos ~s line ~s new-zwin ~S" pos new-lines new-zwin)
            (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                          (line ascent descent lineheight linewidth))
            (incf new-lines)
            (incf pos line)
            (SETQ NEW-ZWIN POS)   ; 3/23
            (incf vpos lineheight)
            (incf new-zmod-line)   ; probably same as new-lines
            (when (>= vpos display-height)
              (setq zmod-line numlines
                    new-zwin pos
                    new-zwin-line new-lines
                    new-zmod-line new-lines)
              (dbmsg " -> NO use of bottom . new-zwin ~S new-lines ~S" new-zwin new-lines)
              (go DRAW-IT))))))

      ; do zmod:zwin
      (unless (eql new-zwin buffer-size) ; (eql zmod buffer-size)  ; changed 5/13
      (setq zmod-vpos vpos  ; wrong?
            new-zmod-line new-lines)
      (dbmsg "~&  new-zmod-line=~S, zmod-line=~s, numlines=~s, vpos=~s, new-lines=~s, zwin=~S, num-whole-lines ~s"
             new-zmod-line zmod-line numlines vpos new-lines zwin num-whole-lines)
      (let ((line-num zmod-line)
            (scroll-up-p (> new-bwin (fr.bwin frec))))
        (loop
          (when (>= vpos display-height)
            (if (null new-zwin)(setq new-zwin my-zwin))  ; 5/13
            (setq zwin-vpos vpos #|new-zwin my-zwin|# new-zwin-line new-lines) ; 5/13
            (go DRAW-IT))
          ; not really right - want to know if the bottom is scrolling up
          (when (and scroll-up-p (>= line-num num-whole-lines)) ; check here for crummy last line???
            (dbmsg  "~&Early return")
            (return))
          (when (>= line-num numlines)
            (return))
          (when (and new-zwin (>= new-zwin buffer-size))   ; 5/13
            (return))
          (setq line (linevec-ref old-linevec line-num)
                lineheight (linevec-ref old-lineheights line-num))
          (unless (eql line-num new-lines)
            (setq ascent (linevec-ref old-ascents line-num)
                  descent (linevec-ref old-descents line-num)
                  linewidth (linevec-ref old-linewidths line-num))
            (dbmsg "~&setting from old ~s to new ~S zwin ~S new-zwin ~s"
                   line-num new-lines zwin new-zwin)
            (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                          (line ascent descent lineheight linewidth)))
          (if (null new-zwin)(setq new-zwin my-zwin)) ; 5/13
          (incf line-num)
          (incf new-lines)
          (incf my-zwin line)
          (incf new-zwin line)  ; ?? ; 5/13 put back
          (incf vpos lineheight)))
      ;(setq new-zwin my-zwin)  ;;<< added this sometime - 5/13 took out
      (setq zwin-vpos vpos))

      NEW-BOTTOM
      ; should have figured out about partial bottom line before this?
      (when (eq 0 new-lines) (setq new-zwin new-bwin))
      (unless  new-zwin  ; unless new-zwin??? which??? - this aint rignt
        (setq new-zwin (if (eq 0 new-lines) new-bwin my-zwin)))
      (setq new-zwin-line new-lines)
      (dbmsg "~&  Compute New bottom: new-zwin=~S new-zwin-line=~S new-lines=~S ~s ~s"
             new-zwin new-zwin-line new-lines vpos zmod)
      (unless (or (>= vpos display-height)
                  ;(>= zmod buffer-size)  ; friday - nuke 4/10
                  (eq 0 buffer-size)
                  ;(eql new-zwin (1- buffer-size)) ; ??? kludge
                  ; fixes copying new char on last line to line below
                  ; but breaks the frob that makes there be an empty last line if no eol
                  ; which in turn makes caret not show up.
                  (eql new-zwin buffer-size)
                  (and new-zwin (> new-zwin buffer-size)))  ; was more stuff here ???
          (progn
            (setq new-bottom-pos new-zwin
                  new-bottom-line  new-lines
                  new-bottom-vpos vpos)
            (loop
              (multiple-value-setq (line ascent descent lineheight linewidth)
                (%compute-screen-line frec new-zwin))
              (dbmsg "~&setting new-zwin ~S line ~s" new-zwin new-lines)
              (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                            (line ascent descent lineheight linewidth))
              (incf new-lines)
              (incf new-zwin line)
              (incf vpos lineheight)
              (when (or (>= vpos display-height)
                        (and (eql new-zwin buffer-size)
                             ; This ensures a blank line at end of buffer.
                             ; I don't understand why it's necessary, but
                             ; Wrapping into the last line from a change above
                             ; there won't work otherwise.
                             ;(eql 0 line)
                             ))
                (return)))))
      (dbmsg "~& New-zwin=~S new-lines=~S" new-zwin new-lines)
      DRAW-IT
      (when bottom-only (go draw-bottom))
      (when nil (and new-zwin (> new-zwin 0)   ; nuke this 4/23? - is a winner
                 (char-eolp (buffer-char buffer  new-zwin)))
        (decf new-zwin)
        (setq new-zwin-return-p t))
      (unless bmod-line-pos (setq bmod-line-pos bmod))
      ;All computed, do actual drawing. new-bwin, bmod, zwin, new-zwin
      (when (and bwin-vpos
                 (< bwin-vpos old-bwin-vpos))
        ; scroll top up
        (let (;(old-bmod-vpos (+ old-bwin-vpos (- bmod-vpos bwin-vpos)))
              (s-bmod-vpos bmod-vpos))
          ;(when new-bmod-line (decf s-bmod-vpos (linevec-ref lineheights new-bmod-line))) ;worse

          (dbmsg "~&scroll top up:  old-bwin-vpos=~s, bwin-vpos=~s, bmod-vpos=~s" 
                 old-bwin-vpos bwin-vpos bmod-vpos)
          #|
          (when (> old-bmod-vpos display-height)
            ; incomplete last line
            (dbmsg "~&Incomplete last line")  ; does this ever happen? I hope not
            ; cause we mean it when we say all computed - no more allowed
            (decf new-zwin-line)
            (let* ((1-numlines (1- numlines))
                   (last-line-height (linevec-ref old-lineheights 1-numlines)))
              (decf my-zwin (linevec-ref old-linevec 1-numlines))
              (decf bmod-vpos last-line-height))
            (decf s-bmod-vpos (- display-height old-bmod-vpos))
            )|#
          ; its scrolling one line too many or too few
          (when (neq bmod bmod-line-pos)  ;???? - seems ok sometimes
            (when new-bmod-line (incf s-bmod-vpos (linevec-ref lineheights new-bmod-line))))
          (scroll-screen-vertically frec old-bwin-vpos bwin-vpos s-bmod-vpos)))
      (when zmod-vpos ;  bmod-vpos is nil - what should it be?
        (setq old-zmod-vpos (if bwin-vpos  ; was just bwin-vpos
                              (+ old-bwin-vpos (- bmod-vpos bwin-vpos))
                              0))
        (let ((idx bmod-line))
          ; (declare (fixnum idx))
          (loop
            (when (>= idx zmod-line) (return))
            (incf old-zmod-vpos (linevec-ref old-lineheights idx))
            (incf idx)))
        (dbmsg "~&here bmod-line ~s zmod-line ~s zmod-vpos ~s old-zmod-vpos ~s"
               bmod-line zmod-line zmod-vpos old-zmod-vpos)
        (when (and (> zmod-vpos old-zmod-vpos)
                   (> zwin-vpos zmod-vpos))  ; ???
          (dbmsg "~&Scroll bottom down. old-zmod-vpos=~s, zmod-vpos=~s, zwin-vpos=~s"
                 old-zmod-vpos zmod-vpos zwin-vpos)
          (scroll-screen-vertically frec old-zmod-vpos zmod-vpos zwin-vpos)))
      (when (and bwin-vpos
                 (> bwin-vpos old-bwin-vpos))
        ; Scroll top down
        (dbmsg "~&Scroll top down. old-bwin-vpos=~s, bwin-vpos=~s, bmod-vpos=~s, new-bwin=~s, new-bwin-line=~s"
               old-bwin-vpos bwin-vpos bmod-vpos new-bwin new-bwin-line)
        (scroll-screen-vertically frec old-bwin-vpos bwin-vpos bmod-vpos)
        ; drawing top only if bwin-vpos
        (%redraw-screen-lines frec new-bwin 0 (1- new-bwin-line)))
      (if (and (eq 0 new-lines)(eql new-zmod-line new-lines))
        ; this guys only job is to clear the screen when scrolling off end?
        (progn
          (setq new-zwin-line new-bmod-line my-zwin bmod-line-pos)
          (dbmsg "~&Displaying to end of screen. bmod-vpos ~s" bmod-vpos)
          (when (<= new-bmod-line new-lines)
            (when (eql 0 new-bmod-line)
              ;Full redisplay, don't bother scrolling
              (setf (fr.hpos frec) (- (fr.margin frec) (fr.hscroll frec))))
            (clear-screen-band frec (or bmod-vpos 0) display-height)))
        (progn
          (when (and zmod-vpos (< zmod-vpos old-zmod-vpos)
                     (neq 0 new-zwin-line)
                     ) ;; ???      ; scroll bottom up
            (dbmsg "~&scrolling bottom up old-zmod-vpos ~s zmod-vpos ~S" old-zmod-vpos zmod-vpos)
            (scroll-screen-vertically frec old-zmod-vpos zmod-vpos zwin-vpos))
          (when (and (not (eql bmod #xffffff)) new-zmod-line)      
            (when (< new-bmod-line new-zmod-line)  ; ??? was <=, or < 5/4
              (let (left)
                ; clear middle
                (decf new-zmod-line)
                (if (or *redraw-whole-line* (eql bmod bmod-line-pos))  ;; << 2006/03/30
                  (%clear-screen-lines frec new-bmod-line new-zmod-line)
                  (let ((max-bmod (+ bmod-line-pos
                                     (linevec-ref linevec new-bmod-line))))
                    ; This erases the end of a line whose last word
                    ; was at the end of the line but has now wrapped to
                    ; the next line
                    (when (> bmod max-bmod) (setq bmod max-bmod))
                    (setq left (new-clear-screen-lines-2
                                frec new-bmod-line new-zmod-line bmod bmod-line-pos zmod bmod-vpos))))
                (dbmsg "~&drawing from bmod ~S new-bmod-line ~s new-zmod-line ~S bmod-vpos ~s left ~s"
                       bmod new-bmod-line new-zmod-line bmod-vpos left)
                ; was x%red
                (%redraw-screen-lines frec bmod-line-pos new-bmod-line new-zmod-line
                                      bmod-vpos bmod left))))))
      DRAW-BOTTOM
      (if (and  #|(not (eql new-zwin-line new-lines))|#  ; 5/12
                (neq 0 new-lines)    ; 5/19
                new-bottom-pos)                    ; draw bottom
        (progn ;when new-bottom-pos  ; maybe this test is enough
          (dbmsg "~&Drawing bottom: new-bottom-line=~s,  new-bottom-pos=~s"
                 new-bottom-line  new-bottom-pos)
          (dbmsg "~&zwin=~s, new-zwin-line=~s, new-lines=~s zwin-vpos=~S"
                 zwin new-zwin-line new-lines zwin-vpos)          
          (clear-screen-band frec new-bottom-vpos display-height) ;(fr.vpos frec))
          (%redraw-screen-lines frec new-bottom-pos new-bottom-line (1- new-lines) new-bottom-vpos)
          )
        (when (and (< vpos display-height)(<= vpos (fr.vpos frec)))
          (unless (fr.nodrawing-p frec)
            (clear-screen-band frec vpos display-height))
          ))
      (when (and ;(eq 0 buffer-size)
                 (eq 0 new-lines))
        ;make sure we have one empty line to keep cursor happy and maybe other things too
        (set-linevecs (linevec ascents descents lineheights linewidths) new-lines
                      (0 0 0 0 0))
        (when (or (eq 0 buffer-size) (null new-zwin))
          (setq new-zwin buffer-size))
        (incf new-lines))
      (when nil
      (let ((ourpos new-bwin))
        (dotimes (i new-lines)
          (incf ourpos (linevec-ref linevec i)))
        (when (> ourpos buffer-size)
          (cerror "Oh dear" "she too big"))))
      #+Testing
      (when (not shouldnt)
        (when (eq frec my-frec)
          (push (format nil "~&~s bmod ~s bzs ~s wpos ~s bwin ~s" (subseq linevec 0 new-lines) bmod buffer-size wpos bwin) stuff))
      (let ((pos new-bwin))
        (when (> new-zwin buffer-size)
          (let ((*debug-io* w)
                (*error-output* w))
            (push 'puke0 stuff)
            (error "new-zwin too big ~a" new-zwin)))
        (dotimes (i new-lines) ; new-lines is 1 too big
          (let ((nchars (linevec-ref linevec i)))
            (when (and (> nchars 1)(char-eolp  (buffer-char buffer pos)))
              (let ((l *top-listener*))
                (when l (let ((p (window-process l)))
                          (when p (deactivate-process p)))))
              (let ((*debug-io* w)
                    (*error-output* w))

                (print (list (buffer-substring buffer pos (+ pos nchars))
                             pos (+ pos nchars) new-bwin) *debug-io*)
                ;(print-call-history)
                (push 'puke5 stuff)
                (setq shouldnt t)
                (validate-view (fr.owner frec))

                (error "shouldnt")))
            (setq pos (+ pos nchars))
            (let ((l *top-listener*))
                (when l (let ((p (window-process l)))
                          (when p (deactivate-process p)))))
            (when (> pos buffer-size)
              (let ((*debug-io* w)
                    (*error-output* w))
                (setq shouldnt t)
                (push 'puke3 stuff)

                (error "shouldnt #3")))))
        (when (< pos new-zwin)
          (let ((l *top-listener*))
                (when l (let ((p (window-process l)))
                          (when p (deactivate-process p)))))
          (let ((*debug-io* w)
                (*error-output* w))
            (setq shouldnt t)
            (push 'puke2 stuff)
            (error "shouldnt #2")))))


      (when (eq 0 new-lines)(cerror "Oh no" "Huh"))
      (when (null new-bwin)
        (error "new-bwin is nil"))
      (setf (fr.vpos frec) (min display-height vpos))
      (setf (fr.numlines frec) new-lines)
      (setf (fr.bwin frec) new-bwin)
      (set-mark (fr.wposm frec) new-bwin)
      (setf (fr.zwin frec) (- buffer-size new-zwin))
      (setf (fr.truezwin frec) new-zwin)
      (setf (fr.zwin-return-p frec) new-zwin-return-p)
      (setf (fr.bmod frec) #xFFFFFF)
      (setf (fr.zmod frec) #xFFFFFF)
      )))

(defun find-pcache-line (frec pos count)
  ; could binary search
  (let* ((linevec para-linevec)
         (n para-lines)
         (start (aref linevec 0))
         next)
    (dotimes (i (1- n) nil)
      (when (<= start pos (setq next (aref linevec (1+ i))))
        (let ((j i))
          (when (eql pos next)
            (setq start next j (1+ j)))
          (if (eq count 0)
            (return start)
            (let ((idx (- j count)))
              (if (>= idx 0)
                (return (aref linevec idx))
                (return (%bwd-screen-line-start frec (aref linevec 0) idx)))))))
      (setq start next))))

; there are 2 of these because returning multiple-values from above confuses something else
(defun find-pcache-next-line (frec pos)
  (declare (ignore frec))
  (let* ((linevec para-linevec)
         (n para-lines)
         (start (aref linevec 0))
         next)
    (dotimes (i (1- n) nil)
      (when (and (<= start pos)
                 (< pos (setq next (aref linevec (1+ i)))))
        (return next))
      (setq start next))))


(defun ff-naughty-script (ff)
  (let* ((real-font (ash ff -16))
         (script (#_FontToScript real-font)))
    (not (memq script *well-behaved-scripts*))))

; back up to first non-roman pos if any
; else before italic or nearby italic
; returns nil if dont need to backup - maybe should return pos
(defun line-redraw-pos (frec line-pos pos)
  (let ((buffer (fr.cursor frec)))
    (with-font-run-vectors
      ; font-count is number of fonts on line, font-starts  is a vector of font starts
      (multiple-value-bind  (font-starts font-ends count)
                            (compute-font-run-positions buffer line-pos pos)
        (declare (fixnum count))
        (let (italic)
          (cond 
           ((> count 60) line-pos) ; not worth the trouble? maybe it is
           ((dotimes (i count)
              (let* ((ppos (svref font-starts i))
                     (ff (buffer-char-font-codes buffer ppos)))
                (if (ff-naughty-script ff)
                  (return ppos)
                  (if (italic-ff-code-p ff) (setq italic t))))))
           (italic 
            (if (eq count 1)
              line-pos
              (let ((ff (buffer-char-font-codes buffer pos)))
                ; if italic at pos  - back up
                (if (italic-ff-code-p ff)
                  (do* ((i (- count 2) (1- i)))
                       ((< i 0) line-pos)
                    (let ((ppos (svref font-starts i)))
                      (if (not (italic-ff-code-p (buffer-char-font-codes buffer ppos)))
                        (return (svref font-ends i)))))
                  ; font change nearby? - this may be wrong if e.g. 1 ital, 1 bold, 1 plain & very slanty
                  (let ((ppos (svref font-starts (- count 1))))
                    (declare (fixnum ppos))
                    (if (< (- pos ppos) 3)  ; is it true that italic can clobber at most 2 chars?
                      (if (eq count 2) line-pos
                          (do* ((i (- count 3)(1- i)))
                               ((< i 0) line-pos)
                            (setq ppos (svref font-starts i))
                            (if (not (italic-ff-code-p (buffer-char-font-codes buffer ppos)))
                              (return (svref font-ends i)))))))))))))))))

  


; Eventually, this should use and refill a cache of lengths
; of lines before the visible ones.
(defun %compute-screen-line-start (frec start-pos)
  ;(frec-arg frec)
  (let* ((pos (ccl::buffer-backward-find-eol (fr.cursor frec) start-pos))
        new-pos)
    (if pos
      (incf pos)
      (setq pos 0))
    (if (eql pos start-pos)
      pos
      (loop
        (setq new-pos (+ pos (%compute-screen-line frec pos)))
        (when (>= new-pos start-pos)
          (if (eql new-pos start-pos)
            (return new-pos)
            (return pos)))
        (when (eql new-pos pos)
          (error "Got a zero-length line"))
        (setq pos new-pos)))))


;Scroll a horizontal band of the screen, updating UpdateRgn, fr.selrgn, fr.bpoint, fr.curpoint.
(defun scroll-screen-vertically (frec old-vstart new-vstart new-vend)
  (setq old-vstart (require-type old-vstart 'fixnum))
  (setq new-vstart (require-type new-vstart 'fixnum))
  (setq new-vend (require-type new-vend 'fixnum)) 
  (locally (declare (fixnum old-vstart new-vstart new-vend))
    (let* ((old-vend (+ old-vstart (- new-vend new-vstart)))
           (v (- new-vstart old-vstart))
           (start 0)
           (end 0))
      (declare (fixnum old-vend v start end))
      (if (<= new-vstart old-vstart)
        (setq start new-vstart end old-vend)
        (setq start old-vstart end new-vend))
      (when (or (fr.nodrawing-p frec) (eql new-vstart new-vend))
        (return-from scroll-screen-vertically
          (clear-screen-band frec start end)))
      (rlet ((rect :rect
                   :top start
                   :bottom end
                   :left 0
                   :right (point-h (fr.size frec))))
        (%scroll-screen-rect rect 0 v (wptr (fr.owner frec)))
        (%scroll-sel-region rect (fr.selrgn frec) 0 v)
        (setf (fr.sel-valid-p frec) nil)
        (macrolet ((scroll-point (accessor)
                     `(let ((point ,accessor)
                            point-v)
                        (declare (fixnum point-v)) ; really?
                        (if (and point 
                                 (and (> (setq point-v (point-v point)) 0)
                                      (>= point-v start)
                                      (<= point-v end)))
                          (progn
                            (incf point-v v)
                            (setf ,accessor
                                (if (and (>= point-v start)
                                         (<= point-v end))
                                  (make-point (point-h point) point-v)                                  
                                  #@(-1 -1))))
                          (setf ,accessor #@(-1 -1))))))          
          (scroll-point (fr.bpoint frec))
          #|
          ; this failed when the cursor (er.. caret) was only half visible at bottom of frec
          ; NOT right yet - may scroll too many times
          ; want to know if curpos is within the scope of this scroll
          (let* ((b-size (buffer-size (fr.cursor frec)))
                 (curpos (fr.curcpos frec))
                 (force (and curpos
                             (>= curpos (fr.bwin frec))
                             (<= curpos (1+ (- b-size (fr.zwin frec)))))))
            (scroll-point (fr.curpoint frec) force))))))
            |#
          ; just say we dont know where caret went and let callers caller (frec-update-internal) fix it
          (setf (fr.curpoint frec) #@(-1 -1))))))
  nil)



(defun rect-and-region-overlap-p (rect region)
  (setq rect (require-type rect 'macptr)
        region (require-type region 'macptr))
  (locally (declare (type macptr rect region))
    (let ((rect-top (pref rect :rect.top))
          (rect-left (pref rect :rect.left)))
      (rlet ((rgnrect :rect))
        (#_getregionbounds region rgnrect)
        (let ((rgn-top (rref rgnrect :rect.top))
              (rgn-left (rref rgnrect :rect.left)))
          (declare (fixnum rect-top rect-left rect-bottom rect-right
                           rgn-top rgn-left rgn-bottom rgn-right))
          (and (if (< rect-top rgn-top)
                 (> (the fixnum (pref rect :rect.bottom)) rgn-top)
                 (< rect-top (the fixnum (pref rgnrect :rect.bottom))))
               (if (< rect-left rgn-left)
                 (> (the fixnum (pref rect :rect.right)) rgn-left)
                 (< rect-left (the fixnum (pref rgnrect :rect.right))))))))))

(defun %scroll-sel-region (rect selrgn h v)
  (when (rect-and-region-overlap-p rect selrgn)
    (locally (declare (type macptr rect selrgn))
      (let ((rect-rgn ccl::*temp-rgn*)
            (rgn ccl::*temp-rgn-2*))
        (declare (type macptr rect-rgn rgn))
        (#_RectRgn rect-rgn rect)
        (#_SectRgn rect-rgn selrgn rgn)
        (#_OffsetRgn rgn h v)
        (#_SectRgn rgn rect-rgn rgn)
        (#_DiffRgn selrgn rect-rgn selrgn)
        (#_UnionRgn selrgn rgn selrgn)))))

; Clear the screen between two lines (inclusive), updating
; UpdateRgn, fr.selrgn, fr.bpoint, fr.curpoint
(defun %clear-screen-lines (frec start-line end-line)
  (let ((vpos 0)
        start-y
        (lineheights (fr.lineheights frec)))
;    (declare (fixnum vpos))
    (dotimes (i start-line)
      (incf vpos (linevec-ref lineheights i)))
    (setq start-y vpos)
    (let ((i start-line))
      (loop
        (when (> i end-line) (return))
        (incf vpos (linevec-ref lineheights i))
        (incf i)))
    (clear-screen-band frec start-y vpos)))

; Same as %clear-screen-lines but
; if start-pos is beyond the beginning of start-line, will erase from
; the end of start-line to the right edge of the screen, unless
; start-line contains fonts with different ascents or descents, in which case
; it will erase the entire line.
; This makes typing update as smoothly as possible without using an
; off-screen line bitmap.
; This should also tell us whether it cleared the whole line or just part
(defun new-clear-screen-lines-2 (frec start-line end-line start-pos line-pos 
                                      &optional end-pos vpos)
  (declare (fixnum start-line end-line start-pos line-pos))
  (declare (optimize (speed 3)(safety 0)))
  (let* (start-y
        (lineheights (fr.lineheights frec))
        left right)
    (when (not vpos)
      (setq vpos 0)
      (dotimes (i start-line)
        (incf vpos (linevec-ref lineheights i))))    
    (setq start-y vpos)
    (locally (declare (fixnum vpos start-y))
      (unless (<= (linevec-ref (fr.linewidths frec) start-line) 0)
        (let ((line-end (+ line-pos (linevec-ref (fr.linevec frec) start-line))))
          (declare (fixnum line-end))
          (when (and (> line-end 0)
                     (char-eolp (buffer-char (fr.cursor frec) (the fixnum (1- line-end)))))
            (decf line-end))
          (case (frec-justification frec line-pos)
            (:left
             (unless (or (<= start-pos line-pos) (> start-pos line-end))             
               (setq left (%screen-line-hpos frec line-pos start-pos line-end nil start-line)
                     right (point-h (fr.size frec)))))
            (:right
             (unless (or (fr.wrap-p frec)        ; should be smarter about this.
                         (null end-pos)
                         (< end-pos line-pos) (>= end-pos line-end))
               (let ((real-end-pos end-pos)
                     (buf (fr.cursor frec)))
                 (when (and (< end-pos (buffer-size buf))
                            (eql #\tab (buffer-char buf end-pos)))
                   (setq real-end-pos (1+ end-pos)))
                 (setq left 0
                       right (%screen-line-hpos
                              frec line-pos real-end-pos line-end nil start-line))))))
          (when left
            (incf vpos (linevec-ref lineheights start-line))
            (incf start-line)
            (clear-screen-band frec start-y vpos left right)
            (setq start-y vpos))))
      (let ((i start-line))
        (declare (fixnum i))
        (loop
          (when (> i end-line) (return))
          (incf vpos (linevec-ref lineheights i))
          (incf i)))
      (when (> vpos start-y)
        (clear-screen-band frec start-y vpos))
      left)))

(declaim (inline line-segments-overlap-p))

(defun line-segments-overlap-p (start1 end1 start2 end2)
  (if (<= start1 start2)
    (>= end1 start2)
    (<= start1 end2)))

; Clear between two vertical positions on the screen, updating
; UpdateRgn, fr.selrgn, fr.bpoint, fr.curpoint.


(defun clear-screen-band (frec start-y end-y &optional (left 0) right)
  (progn ;WITH-BACK-COLOR *WHITE-COLOR*  ; this certainly should be elsewhere - fix cut from fdi
  #-bccl (frec-arg frec)
  (setq start-y (require-type start-y 'fixnum)
        end-y (require-type end-y 'fixnum))
  (locally (declare (fixnum start-y end-y))
    (unless (>= start-y end-y)
      (multiple-value-bind (top-h top-v bot-h bot-v) (screen-caret-corners frec)
        (declare (ignore bot-h))
        (when (and top-h
                   (line-segments-overlap-p top-v bot-v start-y end-y))          
          (setf (fr.curpoint frec) #@(-1 -1))))
      (let ((bpoint-v (point-v (fr.bpoint frec))))
        (declare (fixnum bpoint-v))
        (when (and (<= start-y bpoint-v) (<= bpoint-v end-y))          
          (setf (fr.bpoint frec) #@(-1 -1))))
      (let ((size-h (point-h (fr.size frec))))
        (unless right (setq right size-h))
        (rlet ((rect :rect
                     :top start-y
                     :left left
                     :bottom end-y
                     :right right))
          (setf (fr.sel-valid-p frec) nil)
          (let ((selrgn (require-type (fr.selrgn frec) 'macptr))
                (rgn ccl::*temp-rgn*)
                (rect-rgn ccl::*temp-rgn-2*))
            (declare (type macptr selrgn rgn rect-rgn))
            (#_RectRgn rect-rgn rect)
            (#_GetClip rgn)
            (#_SectRgn rect-rgn rgn rect-rgn)
            (if (fr.nodrawing-p frec)
              (unless (fr.printing-p frec)
                #-carbon-compat 
                (#_InvalRgn rect-rgn)
                #+carbon-compat
                (inval-window-rgn (wptr (fr.owner frec)) rect-rgn))
              (progn
                #-carbon-compat
                (#_ValidRgn rect-rgn)
                #+carbon-compat
                (valid-window-rgn (wptr (fr.owner frec)) rect-rgn)
                (#_EraseRect rect)
                (#_DiffRgn selrgn rect-rgn selrgn)))
            nil)))))))

; return the h coordinate of the pen
(defun %getpen-h ()
  (point-h (%getpen)))  

; Here's where justification is done.
; Returns the beginning and end of the line starting at pos in pixels.
; Returns the justification as a third value.
; Values are relative to the left margin, e.g. left justification always returns 0
; for the beginning of line.
(defun screen-line-ends (frec pos line width)
  (frec-arg frec)
  (let ((line-width (abs (linevec-ref (fr.linewidths frec) line))))
    (let* ((just (frec-justification frec pos))
           (space (ecase just
                   (:left 0)
                   (:center (floor (- width line-width) 2))
                   (:right (- width line-width)))))
      (values space (+ space line-width) just))))

; start pos is beginning of line, real-start may be position later in line
; if real-start provided, left is hpos (in pixels) of real-start

(defun %redraw-screen-lines (frec start-pos start-line end-line &optional vpos 
                                   (real-start start-pos) left)
  (declare (fixnum start-pos start-line end-line))
  (when *redraw-whole-line* (setq real-start start-pos left nil))  ;; << 2006/03/30
  #-bccl (frec-arg frec)
  (progn ;ignore-errors ; last resort
  (when (fr.nodrawing-p frec)
    (return-from %redraw-screen-lines
      ; this seems unhealthy - lets just clear what we may want to redraw.OK?
      (%clear-screen-lines frec start-line end-line)))
  (with-font-run-vectors
    (with-foreground-rgb
      (%stack-block ((tp $max-font-run-length))
        (let* ((linevec (fr.linevec frec))
               (ascents (fr.lineascents frec))
               (lineheights (fr.lineheights frec))
               (linewidths (fr.linewidths frec))
               (buffer (fr.cursor frec))
               (rmargin (point-h (fr.size frec)))
               (font-limit start-pos)
               (fr-hscroll (fr.hscroll frec))
               left-margin right-margin fr-hpos width
               end-pos next-line-pos chars bytes terminator start-hpos
               font-starts font-ends font-count font-index my-vpos my-hpos lineheight linewidth line-ascent)
          (declare (ignore-if-unused bytes lineheight linewidth))
          (unless vpos
            (setq vpos 0)
            (dotimes (i start-line)
              (incf vpos (linevec-ref lineheights i))))
          (loop
            (when (> start-line end-line) (return))
            (multiple-value-setq (left-margin right-margin) (frec-margins frec start-pos))
            (setq fr-hpos (%i- left-margin fr-hscroll)
                  width (%i- right-margin left-margin))
            (let* ((hpos (%i+ fr-hpos (screen-line-ends frec start-pos start-line width))))
              (setq start-hpos hpos)
              (setq line-ascent (linevec-ref ascents start-line))
              (setq my-hpos (or left hpos)
                    my-vpos vpos))
            (incf vpos (setq lineheight (linevec-ref lineheights start-line)))
            (setq linewidth (linevec-ref linewidths start-line))
            (setq next-line-pos (%i+ start-pos (linevec-ref linevec start-line))
                  end-pos (1- next-line-pos))
            (when (or (eql next-line-pos 0) (not (char-eolp (buffer-char buffer end-pos))))
              (setq end-pos next-line-pos))
            (multiple-value-setq (font-starts font-ends font-count)
              (compute-font-run-positions buffer real-start end-pos (fr.line-right-p frec)))
            (setq font-index 0
                  font-limit real-start)
            (let ((start-pos real-start) ff ms)
              (loop
                (when (eql start-pos font-limit)
                  (when (%i>= font-index font-count)
                    (return))
                  (setq start-pos (aref font-starts font-index)
                        font-limit (aref font-ends font-index))
                  (incf font-index)
                  (multiple-value-setq (ff ms) (%set-screen-font buffer start-pos)))
                (multiple-value-setq (chars bytes terminator)
                  (%snarf-buffer-line 
                   buffer start-pos tp
                   (%i- (min font-limit end-pos) start-pos)
                   $max-font-run-length))                
                (incf start-pos chars)
                (when (eql 0 chars)
                  (cond ((char-eolp terminator)
                         (incf start-pos))
                        ((eql terminator #\tab)
                         (let* ((hpos (%i- my-hpos start-hpos))
                                (new-hpos (frec-next-tab-stop frec start-pos hpos)))
                           ;(#_Move (%i- new-hpos hpos) 0)
                           (setq my-hpos (%i+ my-hpos (%i- new-hpos hpos))))
                         (incf start-pos))
                        (t (return))))
                (unless (eql chars 0)
                  (setq my-hpos (experimental-draw-text tp chars my-hpos my-vpos line-ascent
                                                        ;; add tests for #\tab and length > buffer !!
                                                        (if (or (>= chars (1- (ash $max-font-run-length -1)))(eql terminator #\tab)(minusp linewidth)) ;; minus doesn't mean multiple fonts - now it does
                                                          nil ;; multiple fonts
                                                          linewidth)
                                                        ff ms
                                                        )))                      
                (when (%i> my-hpos rmargin) ;;was using (%getpen-h)
                  (return))))
            (setq start-pos next-line-pos
                  real-start next-line-pos
                  left nil
                  start-line (1+ start-line)))))))))


(defvar *weird-fonts* nil)  ;; fonts that drawtheme does better than quickdraw 
#| ;; doesn't boot - font-codes not defined yet - moved to font-menus.lisp
;; other weird fonts are Geeza Pro and Geeza Pro Bold
(def-ccl-pointers gb18030p ()
  (setq *weird-fonts* nil)
  (when (osx-p)
    (let (( gbid (ash (font-codes '("GB18030 Bitmap")) -16))) ;; this is ChineseSimp I think
      (when (neq gbid (ash (sys-font-codes) -16))
        (push gbid *weird-fonts*))
      (let ((geez (ash (font-codes '("Geeza Pro")) -16)))  ;; these are macroman
        (when (neq geez (ash (sys-font-codes) -16))
          (push geez *weird-fonts*))
        (setq geez (ash (font-codes '("Geeza Pro Bold")) -16))
        (when (neq geez (ash (sys-font-codes) -16))
          (push geez *weird-fonts*))))))
      
|#



(defparameter *macroman-char-codes*
  '(160 161 162 163 165 167 168 169 170 171 172 174 175 176 177 180 181 182 183 184 186
    187 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 209 210 211 
    212 213 214 216 217 218 219 220 223 224 225 226 227 228 229 230 231 232 233 234 235
    236 237 238 239 241 242 243 244 245 246 247 248 249 250 251 252 255 305 338 339 376
    402 710 711 728 729 730 731 732 733 937 960 8211 8212 8216 8217 8218 8220 8221 8222 
    8224 8225 8226 8230 8240 8249 8250 8260 8364 8482 8706 8710 8719 8721 8730 8734 8747
    8776 8800 8804 8805 9674 63743 64257 64258))

;; yuck - can it actually be converted to macroman - is there a better way?
#+ignore
(defun ustr-roman-p (ustr-buf numchars)
  (dotimes (i numchars t)
    (declare (fixnum i))
    (let ((code (%get-word ustr-buf (%i+ i i))))
      (declare (fixnum code))
      (when (and (> code #x7f)
                 (not (memq code *macroman-char-codes*)))
        (return nil)))))

;; is this better?
#-ignore
(defun ustr-roman-p (ustr-buf numchars)
  (dotimes (i numchars t)
    (declare (fixnum i))
    (let ((code (%get-word ustr-buf (%i+ i i))))
      (declare (fixnum code))
      (when (and (> code #x7f)
                 (neq #$kcfstringencodingmacroman (%find-encoding-for-uchar-code code)))
        (return nil)))))

;; ugh - caret and blinking paren ugly for small bold fonts - text-width is 1 pixel too short?
(defparameter *use-quickdraw-for-roman* nil)

(defun ff-bold-p (ff)
  (logtest #.(ash #$bold 8) ff))

(defmacro with-atsu-layout ((layout text numchars ff ms) &body body)
  (let ((style-sym (gensym))
        (style-ptr-sym (gensym))
        (layout-ptr-sym (gensym)))
    `(let* ((,style-sym (find-atsu-style ,ff ,ms))
            (,style-ptr-sym (style-ptr ,style-sym)))
       (rlet ((,layout-ptr-sym :atsutextlayout))
         (errchk (require-trap #_ATSUCreateTextLayout ,layout-ptr-sym))         
         (with-macptrs ((,layout (%get-ptr ,layout-ptr-sym)))
           (unwind-protect
            (progn
              (set-layout-line-layout-options-given-layout ,layout *default-layout-options*)
              (errchk (require-trap #_ATSUSetTextPointerlocation ,layout ,text 0 ,numchars ,numchars))
              (errchk (require-trap #_ATSUSetRunStyle ,layout ,style-ptr-sym 0 ,numchars))
              ;; keke 2006-04-27
              ;  *    Transient font matching allows ATSUI to automatically substitute
              ;  *    glyphs from other fonts if the specified styles do not contain
              ;  *    glyphs for all the characters in the text. 
              (errchk (require-trap #_ATSUSetTransientFontMatching ,layout t))
              ,@body)
            (require-trap #_ATSUDisposeTextLayout ,layout)))))))

;; ff and ms always provided today, lineheight previously required not required today
(defun experimental-draw-text (text numchars hpos vpos line-ascent linewidth ff ms)
  ;(declare (ignore-if-unused lineheight))
  ;(when (not (and ff ms))(multiple-value-setq (ff ms) (grafport-font-codes-with-color))) ;;grafport-font-codes omits color
  (if (not (plusp numchars))
    hpos
    (let* (font-id)
      (if (and *use-quickdraw-for-roman*
               (eq (font-to-encoding-no-error (setq font-id (point-v ff))) #$kcfstringencodingmacroman)  ;; monaco 9 is still ugly?? - better now - bold still weird
               (not (memq font-id *weird-fonts*))
               (ustr-roman-p text numchars)) 
        (experimental-draw-roman text numchars hpos vpos line-ascent)
        (with-atsu-layout (layout text numchars ff ms)
          (errchk (#_ATSUdrawtext layout 0 #$kATSUToTextEnd
                   (#_long2fix hpos)
                   (#_long2fix (+ vpos line-ascent))))
          (when (not linewidth)
            (setq linewidth  (atsu-text-width-given-layout layout)))
          ;; if bold inc width by 1 so I can stand using this in Listener - or say (ff-bold-p ff) vs (%get-style-object-face-bold-p style)
          (when (ff-bold-p ff) (setq linewidth (1+ linewidth)))
          (+ hpos linewidth)))))) 

(defun experimental-draw-roman (ustr-buff numchars hpos vpos line-ascent &optional (encoding #$kcfstringencodingmacroman))
  ;(declare (ignore lineheight linewidth))
  (with-macptrs ((cfstr (#_CFstringCreateWithCharacters (%null-ptr)
                         ustr-buff numchars)))
    (let ((buf-len (ash numchars 2))) ;; big enuf ??
      (%stack-block ((out-buf buf-len))
        (rlet ((used-len :signed-long))
          (cfstringGetBytes cfstr 0 numchars encoding #xff nil out-buf buf-len used-len)      
          (let ((to-len (%get-signed-long used-len)))            
            (#_cfrelease cfstr)            
            (#_moveto hpos (+ vpos line-ascent)) ;; ??
            (#_drawtext out-buf 0 to-len)
            ;(+ hpos (or linewidth (#_textwidth out-buf 0 to-len)))
            (%getpen-h)
            ))))))

(defun xtext-width (ustr-buff numchars &optional ff ms)
  (if (not (plusp numchars))
    0
    (progn
      (when (not (and ff ms))(multiple-value-setq (ff ms)(grafport-font-codes)))
      (let* ((font-id)
             (encoding))
        (if (and *use-quickdraw-for-roman*
                 (not (memq (setq font-id (ash ff -16))  *weird-fonts*))
                 (eq (setq encoding (font-to-encoding-no-error font-id)) #$kcfstringencodingmacroman)
                 (ustr-roman-p ustr-buff numchars))
          (with-macptrs ((cfstr (#_CFstringCreateWithCharacters (%null-ptr)
                                 ustr-buff numchars)))        
            (let ((buf-len (ash numchars 3))) ;; big enuf ??
              (rlet ((used-len :signed-long))
                (%stack-block ((out-buf buf-len))            
                  (cfstringGetBytes cfstr 0 numchars encoding #xff nil out-buf buf-len used-len)
                  (#_cfrelease cfstr)
                  (let ((to-len (%get-signed-long used-len)))              
                    (#_textwidth out-buf 0 to-len))))))
          (with-atsu-layout (layout ustr-buff numchars ff ms)              
            (let ((linewidth  (atsu-text-width-given-layout layout))) 
              (when (ff-bold-p ff)(setq linewidth (1+ linewidth)))  ;; bold?
              linewidth)))))))


(defun xpixel-2-char (ustr-buf numchars pos ff ms)
  (let* ((font-id)
         (to-encoding))
    (cond 
     ((and *use-quickdraw-for-roman*
           (not (memq (setq font-id (ash ff -16)) *weird-fonts*))
           (eq (setq to-encoding (font-to-encoding-no-error font-id)) #$kcfstringencodingmacroman)
           (ustr-roman-p ustr-buf numchars))
      (with-macptrs ((cfstr (#_CFstringCreateWithCharacters (%null-ptr)
                             ustr-buf numchars)))
        (let ((loss-byte #xff) ;; ??
              (buf-size (ash numchars 2))) ;; big enuf ?
          (%stack-block ((to-buf buf-size))
            (rlet ((used-len :signed-long)) 
              (cfstringgetbytes cfstr 0 numchars to-encoding loss-byte nil to-buf buf-size used-len)
              (let* ((to-len (%get-signed-long used-len)))              
                (#_cfrelease cfstr)
                (multiple-value-bind (pos-offset leading-edge-p)  ;; pos-offset is in mac encoding bytes
                                     (pixel-2-char to-buf 0 pos 0 to-len)
                  (values pos-offset leading-edge-p))))))))
     (t (with-atsu-layout (layout ustr-buf numchars ff ms)
          (multiple-value-bind (res leading-edge-p off2) (layout-pixel-to-offset-given-layout layout pos)
            (if (and (null leading-edge-p) (<= (logand ms #xffff) 12))(setq res off2)) ;; ?? something about anti-alias?
            (values res leading-edge-p)))))))   

   

#| ; currently unused
(defvar *space-array*
  (make-array 100 :element-type 'base-character :initial-element #\space))
|#

; does both caret and bpchar - fr.caret-on-p dis/en ables blinking
(defun new-toggle-screen-caret (frec)
  (when (fr.caret-on-p frec) ; toggling enabled    
    (let ((selp (frec-selp frec)))
      (unless (or (fr.nodrawing-p frec) selp (fr.frame-sel-p frec))
        (with-foreground-rgb
          (if (fr.bpchar-on-p frec)
            (progn
              (setf (fr.bpchar-on-p frec) nil)
              (bp-and-caret frec  #$SrcBic))
            (progn
              (setf (fr.bpchar-on-p frec) t)
              (bp-and-caret frec #$SrcOr))))))))



#|
(defun bp-and-caret (frec penmode srcmode)
  (declare (ignore penmode))
  (without-interrupts
   (with-fore-color *black-color*
     (multiple-value-bind (top-h top-v bot-h bot-v) (screen-caret-corners frec)
       (when top-h
         (progn ;without-interrupts
           (with-pen-saved-simple
             (#_PenMode #$patxor)
             (#_MoveTo bot-h bot-v)
             (#_LineTo top-h top-v)))))
     (let ((point (fr.bpoint frec)))
       (when (>= point 0)
         (let* ((ff (fr.bp-ff frec))
                (ms (fr.bp-ms frec)))
           (with-font-codes ff (make-point (point-h ms) srcmode)
             (set-grafport-fred-color (logand 255 ff))
             (#_MoveTo (point-h point)(point-v point))
             (#_DrawChar (fr.bpchar frec)))))))))
|#


(defun bp-and-caret (frec srcmode)
  (without-interrupts
   (with-fore-color *black-color*
     (multiple-value-bind (top-h top-v bot-h bot-v) (screen-caret-corners frec)
       (when top-h
         (progn ;without-interrupts
           (with-pen-saved-simple
             (#_PenMode #$patxor)
             (#_MoveTo bot-h bot-v)
             (#_LineTo top-h top-v)))))
     (let ((point (fr.bpoint frec)))
       (when (>= point 0)
         (let* ((ff (fr.bp-ff frec))
                (ms (fr.bp-ms frec)))
           (progn ;with-font-codes ff (make-point (point-h ms) srcmode)
             #|
             (set-grafport-fred-color (logand 255 ff))
             (#_MoveTo (point-h point)(point-v point))
             (#_DrawChar (fr.bpchar frec))
             |#
             (when (eq srcmode #$srcbic)
               (setq ff (logior (logand ff (lognot #xff)) #.(fred-palette-closest-entry *white-color*))))   ;; or (fred-palette-closest-entry (grafport-back-color))
             (let ((*use-quickdraw-for-roman* nil))
               (grafport-write-char-at-point (fr.bpchar frec) point ff ms))            
             )))))))

  

; draw stuff normal and disable blinking
#|
(defun screen-caret-off (frec)
  ; should really be woi - but dont want to pay
  (let ((selp (frec-selp frec)))
    (setf (fr.caret-on-p frec) nil)
    (unless (or #|(fr.nodrawing-p frec)|# selp (fr.frame-sel-p frec))
      (with-foreground-rgb
        (setf (fr.bpchar-on-p frec) t)
        (bp-and-caret frec #$patbic #$SrcOr)))))
|#

(defun screen-caret-off (frec)
  ; should really be woi - but dont want to pay
  (let ((selp (frec-selp frec)))
    (setf (fr.caret-on-p frec) nil)
    (unless (or #|(fr.nodrawing-p frec)|# selp (fr.frame-sel-p frec))
      (when (not (fr.bpchar-on-p frec))
        (with-foreground-rgb
          (setf (fr.bpchar-on-p frec) t)
          (bp-and-caret frec #$SrcOr))))))

; what we want to know is whether there is a selection on the screen now.
(defun frec-selp (frec)
  (or #|(multiple-value-bind (s e) (frec-get-sel frec)
                (neq s e))|#
      (let ((selrgn (fr.selrgn frec)))
        (unless (%null-ptr-p selrgn)
          (not (#_emptyrgn selrgn))))))

#|
; today just enable blinking - better re no lose half caret
; but too slow when fast key repeat
(defun screen-caret-on (frec)
  (setf (fr.caret-on-p frec) t)
  (setf (fr.bticks frec) -1))
|#

 
; draw caret, wipe bpchar and enable blinking better re keep up with fast repeat
; but lose half caret if partly obscured on activate - fixed by view-activate-event-handler
; in l1-edwin - still lose when windoid or choose file dialog
#|
(defun screen-caret-on (frec)
  (unless (fr.caret-on-p frec)
    (let ((selp (frec-selp frec)))
      (unless (or (fr.nodrawing-p frec) selp (fr.frame-sel-p frec))
        (with-foreground-rgb
          (setf (fr.bpchar-on-p frec) nil)
          (bp-and-caret frec #$patcopy #$Srcbic))) ; if background??
      (setf (fr.caret-on-p frec) t))))
|#

(defun screen-caret-on (frec)
  (unless (fr.caret-on-p frec)
    (let ((selp (frec-selp frec)))
      (unless (or (fr.nodrawing-p frec) selp (fr.frame-sel-p frec))
        (when (fr.bpchar-on-p frec)
          (with-foreground-rgb
            (setf (fr.bpchar-on-p frec) nil)
            (bp-and-caret frec #$Srcbic)))) ; if background??
      (setf (fr.caret-on-p frec) t))))
  

#|
;Toggle bpchar at fr.bpoint, or inval it if no drawing.
(defun %toggle-screen-bpchar (frec)
  (let ((point (fr.bpoint frec)))
    (when (>= point 0)
      (let ((ff (fr.bp-ff frec)))
        (with-font-codes ff (fr.bp-ms frec)
          (if (fr.nodrawing-p frec)
            (%inval-char-rect (fr.bpchar frec) point)
            (progn
              (set-grafport-fred-color (logand 255 ff))
              (#_MoveTo :long point)
              (#_DrawChar (fr.bpchar frec)))))))))

; toggle and tell the world we did it - no secrets here
(defun toggle-screen-caret-really (frec)
  (unless nil (eql (fr.curpoint  frec) -1)  ; if we dont know where it is, then leave state alone??
    (without-interrupts
     (setf (fr.caret-on-p frec) (not (fr.caret-on-p frec)))
     (%toggle-screen-caret frec))))

;Toggle caret at fr.curpoint, or inval it if no drawing.
(defun %toggle-screen-caret (frec)
  (multiple-value-bind (top-h top-v bot-h bot-v) (screen-caret-corners frec)
    (when top-h
      (if (fr.nodrawing-p frec)
        (let ((rgn ccl::*temp-rgn*))
          (#_SetRectRgn rgn bot-h top-v (the fixnum (1+ top-h)) (1+ bot-v))
          (#_InvalRgn rgn)
          ;(#_EraseRgn rgn)
          (setf (fr.caret-on-p frec) nil))
        (without-interrupts
         (with-pen-saved
            ; HIT IT WITH A HAMMER - WHEN DOES GETPIXEL FAIL?
           ;  we are losing parity when choose-file-dialog.
           ; actually  dont need both caret-on-p and bpchar-on-p
           (IF (NOT (EQ (#_GETPIXEL top-H top-v)(FR.CARET-ON-P FREC)))
             (PROGN (#_PenMode #$patxor)  ; if in sync, toggle else dont
                    (#_MoveTo bot-h bot-v)
                    (#_LineTo top-h top-v))
             ; if out of sync fix bpchar
             (%TOGGLE-SCREEN-BPCHAR FREC))))
         )))
  nil)
|#

(defun screen-caret-corners (frec)
  (let ((curpoint (fr.curpoint frec))
        (curascent (fr.curascent frec))
        (curdescent (fr.curdescent frec)))
    (when (and curpoint curascent curdescent)
      (locally (declare (fixnum curpoint curascent curdescent))
        (let ((cur-h (point-h curpoint))
              (cur-v (point-v curpoint)))
          (declare (fixnum cur-h cur-v))
          (when (>= cur-v 0)
            (decf curdescent)
            (screen-caret-corners-internal
             cur-h cur-v curascent curdescent (fr.cursor-italic-p frec))))))))

(defun screen-caret-corners-internal (cur-h cur-v curascent curdescent cursor-italic-p)
  (declare (fixnum cur-h cur-v curascent curdescent))
  (symbol-macrolet (($italic-slant-numerator 40)
                    ($italic-slant-denominator 100))
    (let* ((top-h (if cursor-italic-p
                    (+ (incf cur-h) (round (the fixnum (* curascent $italic-slant-numerator))
                                           $italic-slant-denominator))
                    cur-h))
           (top-v (- cur-v curascent))
           (bot-h (if cursor-italic-p
                    (- cur-h (round (the fixnum (* curdescent $italic-slant-numerator))
                                    $italic-slant-denominator) 1)
                    cur-h))
           (bot-v (+ cur-v curdescent)))
      (declare (fixnum curascent curdescent top-h top-v bottom-h bottom-v))
      (values top-h top-v bot-h bot-v))))

(defun new-frec-italic-cursor-p (frec pos)
  (frec-arg frec)
  (let ((buf (fr.cursor frec))
        (pos (if (eql pos 0) pos (1- pos))))
    (and (<= 0 pos)
         (< pos (buffer-size buf))
         (italic-ff-code-p (ccl::buffer-char-font-codes buf pos)))))

(defun make-italic-selection-endcap (selrgn left-side-p h v top bottom)
  (multiple-value-bind (top-h top-v bot-h bot-v)
                       (screen-caret-corners-internal h v (- v top) (- bottom v) t)
    (let ((rgn ccl::*temp-rgn*))
      (#_SetRectRgn rgn bot-h top-v top-h bot-v)
      (#_DiffRgn selrgn rgn selrgn)
      (#_OpenRgn)
      (#_MoveTo top-h top-v)
      (#_LineTo bot-h bot-v)
      (if left-side-p
        (#_LineTo top-h bot-v)
        (#_LineTo bot-h top-v))
      (#_LineTo top-h top-v)
      (#_CloseRgn rgn)
      (#_UnionRgn selrgn rgn selrgn))))

;Compute fr.selrgn from fr.selposns
#| ; Dumb version doesn't know about left-to-right font runs
(defun %screen-selection-region (frec &aux (bwin (fr.bwin frec))
                                         (zwin (- (buffer-size (fr.cursor frec))
                                                  (fr.zwin frec)))
                                         (selrgn (fr.selrgn frec)))
  #-bccl (frec-arg frec)
  (#_SetEmptyRgn selrgn)
  (dolist (marks (fr.selposns frec))
    (let* ((bsel (car marks)) 
           (zsel (cdr marks))
           (bsel-italic-p (new-frec-italic-cursor-p frec (1+ bsel)))
           (zsel-italic-p (new-frec-italic-cursor-p frec zsel))
           (hpos (fr.hpos frec))
           (frame-sel-p (fr.frame-sel-p frec))
           (hpos-1 (if frame-sel-p hpos (- hpos 1)))
           (past-zwin-p nil))
      (cond ((< bsel bwin)
             (setq bsel bwin
                   bsel-italic-p nil))
            ((> bsel zwin) (setq bsel zwin)))
      (cond ((< zsel bwin)
             (setq zsel bwin
                   zsel-italic-p nil))
            ((> zsel zwin)
             (setq zsel zwin
                   zsel-italic-p nil
                   past-zwin-p t)))
      (when (and (< bsel zsel) (< bsel zwin))
        (multiple-value-bind (bpoint bline) (%screen-char-point frec bsel)
          (multiple-value-bind (zpoint zline) (%screen-point frec zsel)
            (let* ((size (fr.size frec))
                   (size-h (point-h size))
                   (size-v (point-v size))
                   (bpoint-h (point-h bpoint))
                   (bpoint-v (point-v bpoint))
                   (zpoint-h (if past-zwin-p size-h (point-h zpoint)))
                   (zpoint-v (point-v zpoint))
                   (bline-1 (1- bline))
                   (ascents (fr.lineascents frec))
                   (descents (fr.linedescents frec))
                   (lineheights (fr.lineheights frec))
                   (rgn ccl::*temp-rgn*)
                   leading left top right bottom)
              (when frame-sel-p (incf size-h))
              (when (and (>= zsel zwin) (fr.text-edit-sel-p frec))
                (setq zpoint (make-point (setq zpoint-h size-h) zpoint-v)))
              (when (eql hpos bpoint-h)
                (setq bpoint (make-point (setq bpoint-h hpos-1) (point-v bpoint))))
              (when (eql hpos zpoint-h)
                (setq zpoint (make-point (setq zpoint-h hpos-1) zpoint-v)))
              ; compute region for first line
              (setq leading (if (>= bline-1 0)
                              (- (linevec-ref lineheights bline-1)
                                 (+ (linevec-ref ascents bline-1)
                                    (linevec-ref descents bline-1)))
                              0)
                    left bpoint-h
                    top (- bpoint-v (linevec-ref ascents bline) (floor leading 2))
                    leading (- (linevec-ref lineheights bline)
                               (+ (linevec-ref ascents bline)
                                  (linevec-ref descents bline)))
                    right (if (eql bline zline) zpoint-h size-h)
                    bottom (+ bpoint-v (linevec-ref descents bline) (ceiling leading 2)))
              (#_SetRectRgn selrgn left top right bottom)
              (when bsel-italic-p
                (make-italic-selection-endcap selrgn t bpoint-h bpoint-v top bottom))
              (when (> zline bline)
                (incf bline)
                (when (> zline bline)
                  ; middle rectangle
                  (setq left hpos-1
                        top bottom
                        leading (let ((zline-1 (1- zline)))
                                  (- (linevec-ref lineheights zline-1)
                                     (+ (linevec-ref ascents zline-1)
                                        (linevec-ref descents zline-1))))
                        right size-h
                        bottom (- zpoint-v (linevec-ref ascents zline) (floor leading 2)))
                  (#_SetRectRgn rgn left top right bottom)
                  (#_UnionRgn rgn selrgn selrgn))
                ; Bottom rectangle
                (setq left hpos-1
                      top bottom
                      leading (- (linevec-ref lineheights zline)
                                 (+ (linevec-ref ascents zline)
                                    (linevec-ref descents zline)))
                      right zpoint-h
                      bottom (+ zpoint-v (linevec-ref descents zline) 
                                (ceiling leading 2)))
                (#_SetRectRgn rgn left top right bottom)
                (#_UnionRgn rgn selrgn selrgn))
              (when zsel-italic-p
                (make-italic-selection-endcap selrgn nil zpoint-h zpoint-v top bottom))
              (when frame-sel-p
                (#_CopyRgn selrgn rgn)
                (#_InsetRgn rgn 1 1)
                (#_DiffRgn selrgn rgn selrgn))
              (#_SetRectRgn rgn -1 0 size-h size-v)
              (#_SectRgn rgn selrgn selrgn))))))))
|#

; doesn't Know about left-to-right font runs
; Update for justification
(defun %screen-selection-region (frec &aux (bwin (fr.bwin frec))
                                      (zwin (- (buffer-size (fr.cursor frec))
                                               (fr.zwin frec)))
                                      (selrgn (fr.selrgn frec)))
  #-bccl (frec-arg frec)
  (#_SetEmptyRgn selrgn)
  (with-font-run-vectors
    (with-foreground-rgb
      (dolist (marks (fr.selposns frec))
        (let* ((buf (fr.cursor frec))
               (buf-size (buffer-size buf))
               (bsel (car marks)) 
               (zsel (cdr marks))
               (bsel-italic-p (new-frec-italic-cursor-p frec (1+ bsel)))
               (zsel-italic-p (new-frec-italic-cursor-p frec zsel))
               (hscroll (fr.hscroll frec))
               (line-right-p (fr.line-right-p frec))
               (numlines (fr.numlines frec))
               hpos min-h left-margin right-margin left right just
               text-edit-sel-left text-edit-sel-right
               (frame-sel-p (fr.frame-sel-p frec))
               (text-edit-sel-p (fr.text-edit-sel-p frec))
               (size (fr.size frec))
               (size-h (point-h size))
               (size-v (point-v size))
               (rgn ccl::*temp-rgn*)
               first-h first-top first-bottom first-descent
               last-h last-top last-bottom last-descent found-a-right-to-left-p)
          (when (and (< zwin buf-size)
                     (char-eolp (buffer-char buf zwin)))
            (incf zwin))                  ; make sure we include a final blank line.
          (cond ((< bsel bwin)
                 (setq bsel bwin))
                ((> bsel zwin) (setq bsel zwin)))
          (cond ((< zsel bwin)
                 (setq zsel bwin))
                ((> zsel zwin)
                 (setq zsel zwin)))
          (when (and (< bsel zsel) (< bsel zwin))
            (multiple-value-bind (line line-pos) (frec-screen-line-num frec bsel)
              (when line ; << added this
                (let* ((linevec (fr.linevec frec))
                       (lineheights (fr.lineheights frec))
                       (vpos (let ((vpos 0))
                               (dotimes (i line vpos)
                                 (incf vpos (linevec-ref lineheights i)))))
                       (descents (fr.linedescents frec))
                       next-descent
                       next-line-pos line-end-pos next-vpos
                       font-starts font-ends h
                       start-h end-h last-start-h last-end-h ff ms left-to-right-p run-pos bytes len
                       start end sel-start sel-end
                       (font-count 0))
                  (declare (fixnum font-count))
                  (DECLARE (ignore-if-unused bytes))
                  (%stack-block ((tp $max-font-run-length))
                    (loop   ; for each line
                      (multiple-value-setq (left-margin right-margin) (frec-margins frec line-pos))
                      (multiple-value-setq (left right just)
                        (screen-line-ends frec line-pos line (- right-margin left-margin)))
                      (setq min-h (- left-margin hscroll)
                            hpos (+ min-h left))
                      (when text-edit-sel-p
                        (if (eq just :right)
                          (setq text-edit-sel-left 0
                                text-edit-sel-right (+ right min-h))
                          (setq text-edit-sel-left min-h
                                text-edit-sel-right size-h)))
                      (setq next-line-pos (+ line-pos (linevec-ref linevec line)))
                      (setq line-end-pos (1- next-line-pos))
                      (when (or (eql 0 next-line-pos)
                                (not (char-eolp (buffer-char buf line-end-pos))))
                        (setq line-end-pos next-line-pos))
                      (setq next-vpos (+ vpos (linevec-ref lineheights line)))
                      (setq next-descent (linevec-ref descents line))
                      (multiple-value-setq (font-starts font-ends font-count)
                        (compute-font-run-positions buf line-pos line-end-pos (fr.line-right-p frec)))
                      (setq last-start-h nil
                            last-end-h nil
                            h hpos)
                      (flet ((emit-rect ()
                               (let ((start-h (if frame-sel-p
                                                (1- last-start-h)
                                                last-start-h)))
                                 (unless first-h
                                   (setq first-h start-h
                                         first-top vpos
                                         first-bottom next-vpos
                                         first-descent next-descent))
                                 (setq last-h last-end-h
                                       last-top vpos
                                       last-bottom next-vpos
                                       last-descent next-descent)
                                 ;; beware h > 32767, how bout v??, why don't we quit when beyond size-h size-v
                                 (#_SetRectRgn rgn (min start-h #x7fff) vpos (min last-end-h #x7fff) next-vpos)
                                 (#_UnionRgn rgn selrgn selrgn))))
                        (declare (dynamic-extent emit-rect))
                        (if (and (<= bsel line-pos)
                                 (> zsel line-end-pos)) ; << was >=
                          ; optimization when entire line selected
                          (if text-edit-sel-p
                            (setq last-start-h text-edit-sel-left
                                  last-end-h text-edit-sel-right)
                            (setq last-start-h (+ left min-h)
                                  last-end-h (+ right min-h)))
                          ; << added special case - first char is eol
                          (if (and (= bsel line-end-pos) text-edit-sel-p)
                            (setq last-end-h text-edit-sel-right
                                  last-start-h (+ right min-h))
                            (dotimes (i font-count)
                              (setq start (aref font-starts i)
                                    end (aref font-ends i)
                                    sel-start (max start bsel)
                                    sel-end (min end zsel))
                              (let ((gotone? (< sel-start sel-end)))
                                ; It's a shame we can't just call %screen-line-width here, oh really?
                                ; but that was way too slow
                                (multiple-value-setq (ff ms)(%set-screen-font buf start))
                                (setq left-to-right-p (ff-left-to-right-p ff))
                                (unless left-to-right-p
                                  (setq found-a-right-to-left-p t))
                                (let ((pos start))
                                  (setq start-h nil end-h nil)
                                  (when gotone?
                                    (if left-to-right-p
                                      (when (eql start sel-start)
                                        (setq start-h h))
                                      (when (eql end sel-end)
                                        (setq end-h h)))
                                    (when (and text-edit-sel-p
                                               (eql i 0))
                                      (if left-to-right-p
                                        (when (and (eql sel-start start)
                                                   (or (not line-right-p)
                                                       (eql sel-end end)))
                                          (setq start-h text-edit-sel-left))
                                        (when (and (eql sel-end end)
                                                   (or line-right-p
                                                       (eql sel-start start)))
                                          (setq end-h text-edit-sel-left)))))
                                  (loop
                                    (when (>= pos end)
                                      (return))
                                    (multiple-value-setq (len bytes)
                                      (%snarf-buffer-line buf pos tp (- end pos) $max-font-run-length))
                                    (cond ((eql 0 len)
                                           ; tab character
                                           (when (and (null start-h) (eql sel-start pos))
                                             (setq start-h h))
                                           (when (and (null end-h) (eql sel-end pos))
                                             (setq end-h h))
                                           (setq h (+ hpos (frec-next-tab-stop frec pos (- h hpos))))
                                           (incf pos)
                                           (when (and (null start-h) (eql sel-start pos))
                                             (setq start-h h))
                                           (when (and (null end-h) (eql sel-end pos))
                                             (setq end-h h)))
                                          (t
                                           (when gotone?
                                             (when (and (null start-h)
                                                        (< 0 (setq run-pos (- sel-start pos)) len))
                                               (let ()
                                                 (setq start-h
                                                       (+ h (xtext-width tp run-pos ff ms)))))
                                             ;; one of these is about right-to-left which ain't gonna work
                                               
                                             (when (and (null end-h)
                                                        (< 0 (setq run-pos (- sel-end pos)) len))
                                               (let ()
                                                 (setq end-h
                                                       (+ h (xtext-width tp run-pos ff ms))))))
                                           (incf h (xtext-width tp len ff ms))
                                           (incf pos len))))
                                  (when gotone?
                                    (if left-to-right-p
                                      (when (eql end sel-end)
                                        (if start-h
                                          (setq end-h h)
                                          (setq start-h h)))
                                      (when (eql start sel-start)
                                        (if start-h
                                          (setq end-h h)
                                          (setq start-h h))))
                                    (when (> start-h end-h)
                                      (rotatef start-h end-h))
                                    (unless (eql start-h last-end-h)
                                      (when last-start-h
                                        (emit-rect))
                                      (setq last-start-h start-h))
                                    (setq last-end-h end-h)))))))
                        (when text-edit-sel-p
                          (if  (and (eql line-pos line-end-pos)(not (eql line-end-pos zsel)))
                            (setq last-start-h text-edit-sel-left
                                  last-end-h text-edit-sel-right)
                            (when (if left-to-right-p
                                    (and (eql end sel-end)
                                         (not (eql line-end-pos zsel))  ; << added this
                                         (or (not line-right-p)
                                             (eql start sel-start)))
                                    (and (eql start sel-start)
                                         (or line-right-p
                                             (eql end sel-end))))
                              (setq last-end-h text-edit-sel-right))))
                        (when last-start-h
                          (emit-rect)))
                      (setq line-pos next-line-pos
                            vpos next-vpos
                            line (1+ line))
                      (when (or (> line-pos zsel)
                                (>= line-pos buf-size)
                                (>= line numlines))
                        (return)))))
                ; Put on the italic endcaps
                ; Don't do them if there were any right-to-left font runs. That's too hard for my brain right now. -Bill
                (when (and first-h (not found-a-right-to-left-p))
                  (when bsel-italic-p
                    (make-italic-selection-endcap selrgn t first-h (- first-bottom first-descent) first-top first-bottom))
                  (when zsel-italic-p
                    (make-italic-selection-endcap selrgn nil last-h (- last-bottom last-descent) last-top last-bottom)))
                (when frame-sel-p
                  (#_CopyRgn selrgn rgn)
                  (#_InsetRgn rgn 1 1)
                  (#_DiffRgn selrgn rgn selrgn))
                (#_SetRectRgn rgn -1 0 size-h size-v)
                (#_SectRgn rgn selrgn selrgn)))))))))

; Returns two values
; 1) The point where POS is on the screen or NIL if off-screen
; 2) The screen line number of that point, or NIL if on the blank line at the end
;    of the buffer.
(defun %screen-point (frec pos &optional screen-char-point? script)
  ;(declare (fixnum pos))
  #-bccl (frec-arg frec)
  (let* ((buffer-size (buffer-size (fr.cursor frec)))
         (bwin (fr.bwin frec))
         (zwin (- buffer-size (fr.zwin frec))))
    (declare (fixnum buffer-size bwin zwin))
    (when (fr.zwin-return-p frec) (incf zwin))
    (when (and (<= bwin pos) (<= pos zwin))
      (let* ((linevec (fr.linevec frec))
             (lineheights (fr.lineheights frec))
             (numlines (fr.numlines frec))
             (line-num 0)
             (new-bwin 0)
             (buf (fr.cursor frec))
             (buf-size (buffer-size buf))
             (v 0)
             line-length)
        (declare (fixnum new-bwin v line-num))
        (loop
          (when (or (eql line-num numlines)
                    (eql 0 (setq line-length (linevec-ref linevec line-num))))
            ; Cursor at end of buffer after newline.
            (when (and (eql pos buf-size)  ; 1/10/96
                       (neq buf-size 0)
                       (eq v 0)
                       (not (char-eolp (buffer-char buf (1- pos)))))
              (return-from %screen-point nil))
            (multiple-value-bind (ff ms) (ccl::buffer-font-codes buf)
              (return-from %screen-point
                (make-point (fr.hpos frec) (+ v (font-codes-info ff ms))))))
          (setq new-bwin (+ bwin line-length))
          (when (and (<= pos new-bwin)
                     (not (and (eql pos new-bwin)
                               (or (and screen-char-point? (not (eql pos buf-size)))
                                   (and (> pos 0)
                                        (char-eolp (buffer-char buf (1- pos))))))))
            (return))
          (setq bwin new-bwin)
          (incf v (linevec-ref lineheights line-num))
          (incf line-num))
        (let ((h (%screen-line-hpos frec bwin pos new-bwin script)))
          ; This form prevents horizontal scrolling when a space at the end
          ; of the line goes past the end of line. This will need to be
          ; modified when a ruler controls the horizontal size (see if we're
          ; past the end of the ruler, not the end of the display).
          (when (fr.word-wrap-p frec)
            (let ((max-h (point-h (fr.size frec)))
                  (new-pos pos)
                  new-h
                  char)
              (when (and (>= h max-h)
                         (dotimes (i (- new-bwin pos) t)
                           (unless (or (eql #\space (setq char (buffer-char buf (+ pos i))))
                                       (eql #\tab char)
                                       (char-eolp char))
                             (return nil))))
                (loop
                  (unless (and (> new-pos 0)
                             (or (eql #\space (setq char (buffer-char buf (decf new-pos))))
                                 (eql #\tab char)))
                    (return))
                  (setq new-h (%screen-line-hpos frec bwin new-pos new-bwin script))
                  (when (< new-h max-h)
                    (setq h (1- max-h))
                    (return))))))
          (values
           (if (> h #x7fff)  ; 4/26  - what does this break vs crashing here -broke search using hmax - just dont crash using #x7fff 5/3
             nil
             (make-point h
                       (+ v (linevec-ref (fr.lineascents frec) line-num))))
           line-num))))))

;Return the screen position of char at pos (pos < buffer size).  Differs
;from %screen-point when wrap - in that case %screen-point returns the
;end of last line, where the cursor goes, %screen-char-point returns the
;position on next line, where the actual character goes.
(defun %screen-char-point (frec pos &optional script)
  (%screen-point frec pos t script))

(defun frec-linenum (frec pos &optional prefer-line-end?)
  #-bccl (frec-arg frec)
  (setq pos (require-type pos 'fixnum))
  (locally (declare (fixnum pos))
    (when (and (<= (fr.bwin frec) pos)
               (<= pos (- (buffer-size (fr.cursor frec)) (fr.zwin frec))))
      (let ((linevec (fr.linevec frec))
            (p (fr.bwin frec))
            (numlines (fr.numlines frec)))
        (declare (fixnum p numlines))
        (dotimes (i numlines 
                    (if (eql p pos) (1- numlines) (error "Didn't find pos!")))
          (when (>= (incf p (linevec-ref linevec i)) pos)
            (when (or (> p pos) prefer-line-end?)
              (return i))))))))


; Invalidate the rectangle for the given char at the given position in the current font
; This may end up being quite slow, but I doubt it gets called very often.
; screw it - not called at all
#-carbon-compat
(defun %inval-char-rect (char point &optional truetype-p)
  (let ((h (point-h point))
        (v (point-v point))
        (rgn ccl::*temp-rgn*)
        max-y min-y)
    (ccl::with-truetype-flags truetype-p
      (multiple-value-bind (a d w l) (font-info)
        (declare (ignore l))
        (if truetype-p
          (%stack-block ((string 1))
            (setf (%get-byte string) (char-code char))
            (multiple-value-setq (max-y min-y)
              (ccl::string-max-and-min-y string :start 0 :end 1)))
          (setq max-y a min-y (- d)))
        (#_SetRectRgn rgn h (- v max-y) (+ h w) (- v min-y))
        (#_InvalRgn rgn)))))

#|
(defun frec-idle (frec)
  (progn ;with-frec (frec frec)
    (let* ((keyscript (get-key-script))
           (buf (fr.cursor frec))
           (encoding (ff-encoding (buffer-font-codes buf)))
           (script-p (memq encoding *script-list*)))      
      (when (and script-p (not (fr.keyscript frec)))        
        (setf (fr.keyscript frec) encoding))
      (when (and script-p (not (eql keyscript (fr.keyscript frec))))
        (multiple-value-bind (ff ms)
                             (buffer-find-font-in-script buf keyscript)
          (buffer-set-font-codes buf ff ms))
        (setf (fr.keyscript frec) keyscript)))
    (when (>= (- (#_tickcount) (fr.bticks frec)) (#_GetCaretTime))
      (without-interrupts  ;; put this back for carbon? - doesn't help
        (when (fr.caret-on-p frec)
          (new-toggle-screen-caret frec)
          (setf (fr.bticks frec) (#_tickcount))))))) 
|#

(defun frec-idle (frec)
  (progn ;with-frec (frec frec)
    (let* ((keyscript (get-key-script))  ;; can be #$smUnicodeScript = 126
           (buf (fr.cursor frec))
           (script (ff-script (buffer-font-codes buf))))
      (when (and (not (fr.keyscript frec)))        
        (setf (fr.keyscript frec) script))
      (when (and (not (eql keyscript (fr.keyscript frec))))
        (multiple-value-bind (ff ms)
                             (buffer-find-font-in-script buf keyscript)
          (buffer-set-font-codes buf ff ms))
        (setf (fr.keyscript frec) keyscript)))
    (without-interrupts  ;; put this back for carbon? - doesn't help
     (when (and (fr.caret-on-p frec) (or (eq (fr.bticks frec) 0)(>= (%tick-difference (get-tick-count) (fr.bticks frec)) (#_GetCaretTime))))
       (new-toggle-screen-caret frec)
       (setf (fr.bticks frec) (get-tick-count))))))



(defun frec-delay-cursor-off (frec &optional turn-on-now-p)
  (frec-arg frec)
  (if (fr.caret-on-p frec)
    (setf (fr.bticks frec) (get-tick-count))
    (when turn-on-now-p ;; always true
      (setf (fr.bticks frec) 0) ;;  0 is used as a magic incantation for a "long" time ago 
                                ;; will fail if (get-tick-count) manages to actually BE 0
                                ;; but i think that only means it will toggle once or twice too often
      (frec-idle frec)  ;; pointless because fr.caret-on-p is nil?? but maybe we care about the keyscript stuff
      )))

;Point in frec where cursor at pos would go, or NIL if char not on screen.
;Assumes display valid.
(defun frec-pos-point (frec pos)
  (frec-arg frec)
  (setq pos (buffer-position (fr.cursor frec) pos))
  (if (and (eql pos (fr.curcpos frec)) (not (eql #@(-1 -1) (fr.curpoint frec))))
    (fr.curpoint frec)
    (progn ;with-frec (frec frec)
      (%screen-point frec pos))))

(defun next-screen-context-lines (screen-height)
  (let ((context *next-screen-context-lines*))
    (if (floatp context)
      (round (* context screen-height))
      (if (and (fixnump context) (<= 0 context) (< context screen-height))
        context
        0))))

; frec has to be up to date when this is called.
; and it wasnt telling us if horizontally visible?
(defun frec-pos-visible-p (frec pos)
  (without-interrupts  ; added 4/30
   (when (not (frec-up-to-date-p frec))
     (with-focused-view (fr.owner frec)
       (frec-update frec t)))
   (let ((buffer (fr.cursor (frec-arg frec))))
     (setq pos (buffer-position buffer pos))
     (let ((point (frec-pos-point frec pos)))
       (and point
            (let* ((size (fr.size frec))
                   (numlines (fr.numlines frec)))
              (if (eq numlines 0)
                (eq pos 0)
                (and (>= (point-v size)
                         (+ (point-v point)
                            (linevec-ref (fr.linedescents frec)
                                         (1- numlines))))
                     (>= (point-h size)  ; not exactly right but better than nothing
                         (point-h point))))))))))

;Do an update, scrolling if necessary to bring pos into view
(defun frec-show-cursor (frec &optional pos scrolling &aux point v h (buffer (fr.cursor frec)))
  (frec-arg frec)
  (without-interrupts
   (frec-update frec)
   (setq pos (buffer-position (fr.cursor frec) pos))
   (when (setq point (frec-pos-point frec pos))
     (setq v (point-v point) h (point-h point)))
   (when (or (null point)
             (let ((numlines (fr.numlines frec)))
               (or (eq numlines 0)
                   (<= (point-v (fr.size frec))
                       (%i+ v (linevec-ref (fr.linedescents frec)
                                         (1- numlines)))))))
     (dbmsg "~&Vscroll, point=~A v=~S" (if point (point-string point)) v)
     (progn ;with-frec (frec frec)
       (let* ((lines (%frec-full-lines frec))
              (context (next-screen-context-lines lines))
              (bpos (%frec-screen-line-start frec pos)))
         ;If scrolling off the last line, just leave context lines at the bottom
         (when (or scrolling point
                   (eq pos (%i- (buffer-size buffer) (fr.zwin frec))))
           (setq context (max 0 (%i- lines (%i+ context 1)))))   ; << no negative plz
         (dbmsg " lines=~S context=~S" lines context)
         (set-mark (fr.wposm frec)
                   (%frec-screen-line-start frec bpos (- context)))
         (when (null point)
           (setq h (%screen-line-hpos
                    frec bpos pos (%frec-screen-line-start frec bpos 1))))))
     (setq point nil))
   (cond ((<= h 0)
          (frec-add-hscroll frec (%i- h (fr.margin frec)))          
          (setq point nil))
         ((fr.wrap-p frec))            ; eventually, wrap size may not = size
         ((< (point-h (fr.size frec)) (setq h (%i+ h (fr.margin frec))))
          (frec-add-hscroll frec (%i- h (floor (* 3 (point-h (fr.size frec))) 4)))          
          (setq point nil)))
   (when (null point) (frec-update frec))))

#| ; not used
(defun frec-vscroll (frec &optional (lines 1))
  (frec-arg frec)
  (set-mark (fr.wposm frec) 
            (frec-screen-line-start 
             frec (%buffer-position (fr.wposm frec)) lines))
  (frec-update frec))
|#


(defun frec-activate (frec)
  (frec-arg frec)
  (without-interrupts
   (with-frec (frec frec)
     (let ((owner (fr.owner frec)))  ; 6/17/95
       (when (eq owner (current-key-handler (view-window owner)))
         (let* ((encoding (ff-encoding (buffer-font-codes (fr.buffer frec))))
                (script-p (memq encoding *script-list*)))
           (when script-p
             (let ((keyscript (get-key-script)))
               (when (null (fr.keyscript frec))
                     (setf (fr.keyscript frec) encoding))
               (when (not (eql keyscript (fr.keyscript frec)))
                 (set-key-script (fr.keyscript frec)))))))
         (setf (fr.caret-on-p frec) t))
     ;(setf (fr.keyscript frec) (get-key-script))     
     (setf (fr.frame-sel-p frec) nil)
     (setf (fr.bticks frec) 0)  ;; added this ?? in case has been in background for 3 months
     ;(setf (fr.caret-on-p frec) t)  ;; dont do unless current key-handler??
     )))

(defun frec-deactivate (frec)
  (frec-arg frec)
  (ccl::set-buffer-insert-font-index (fr.cursor frec) nil)  ;; why ??
  (without-interrupts
   (frec-turn-off-blinkers frec)
   (setf (fr.frame-sel-p frec) t)
   ))

#|
(defun frec-turn-off-blinkers (frec)
  (if (eq frec my-frec)
    (%frec-turn-off-blinkers frec)
    (with-frec (frec frec)  ; with-frec clobbers nodrawing bit�
      
      (when (not (fr.bpchar-on-p frec))
        (setf (fr.bpchar-on-p frec) t)
        (%toggle-screen-bpchar frec))
      (screen-caret-off frec))))
|#


(defun frec-turn-off-blinkers (frec)
  (let ((no-drawing (fr.nodrawing-p frec)))
    (unwind-protect
      (with-frec (frec frec)  ; with-frec clobbers nodrawing bit    
        (%frec-turn-off-blinkers frec))
      (setf (fr.nodrawing-p frec) no-drawing))))

#|
(defun %frec-turn-off-blinkers (frec)
  (if (eq frec my-frec)
    (screen-caret-off frec)
    (let ((no-drawing (fr.nodrawing-p frec)))
      (without-interrupts
       (setf (fr.nodrawing-p frec) nil)
       (when (not (fr.bpchar-on-p frec))
         (setf (fr.bpchar-on-p frec) t)
         (%toggle-screen-bpchar frec))
       (when (fr.caret-on-p frec)
         (toggle-screen-caret-really frec))
       (setf (fr.nodrawing-p frec) no-drawing)))))
|#

(defun %frec-turn-off-blinkers (frec)
  (screen-caret-off frec))

(defvar *italic-i-beam-cursor*)
(defvar *contextual-menu-cursor* :contextual-menu-arrow-cursor)

;;; make then all pointers
(ccl::def-ccl-pointers *italic-i-beam-cursor* ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(10 4)))
        (data #(#b0000000000000000
                #b0000000110001100
                #b0000000001010000
                #b0000000000100000
                #b0000000000100000
                #b0000000001000000
                #b0000000001000000
                #b0000000010000000
                #b0000000111000000
                #b0000000010000000
                #b0000000100000000
                #b0000000100000000
                #b0000001000000000
                #b0000001000000000
                #b0000010100000000
                #b0001100011000000)))
    #-interfaces-3
    (dotimes (i 16)
      (setf  (href cursor (:cursor.data.array i)) (svref data i)
             (href cursor (:cursor.mask.array i)) 0))
    #+interfaces-3
    (dotimes (i 16)
      (setf (pref cursor (:cursor.data.contents i)) (svref data i)
            (pref cursor (:cursor.mask.contents i)) 0))
    (setq *italic-i-beam-cursor* cursor)))

(def-ccl-pointers vertical-ps ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(8 7)))
        (data #(#b0000000000000000
                #b0000000010000000
                #b0000000111000000
                #b0000001111100000
                #b0000000010000000
                #b0000000010000000
                #b0011111111111100
                #b0000000000000000
                #b0011111111111100
                #b0000000010000000
                #b0000000010000000
                #b0000001111100000
                #b0000000111000000
                #b0000000010000000
                #b0000000000000000
                #b0000000000000000))
        (mask #(#b0000000010000000
                #b0000000111000000
                #b0000001111100000
                #b0000011111110000
                #b0000000111000000
                #b0011111111111100
                #b0011111111111100
                #b0011111111111100
                #b0011111111111100
                #b0011111111111100
                #b0000000111000000
                #b0000011111110000
                #b0000001111100000
                #b0000000111000000
                #b0000000010000000
                #b0)))
    (dotimes (i 16)
        (setf (pref cursor (:cursor.data.contents i)) (svref data i)
              (pref cursor (:cursor.mask.contents i)) (svref mask i)))
    (setq *vertical-ps-cursor* cursor)))

(def-ccl-pointers horizontal-ps ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(7 7)))
        (data #(#b0000000000000000
                #b0000000000000000
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0001001010010000
                #b0011001010011000
                #b0111111011111100
                #b0011001010011000
                #b0001001010010000
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0000000000000000
                #b0000000000000000
                ))
        (mask #(#b0
                #b0000011111000000
                #b0000011111000000
                #b0001011111010000
                #b0011011111011000
                #b0111011111011100
                #b-10
                #b-1
                #b-10
                #b0111011111011100
                #b0011011111011000
                #b0001011111010000
                #b0000011111000000
                #b0000011111000000
                #b0000011111000000
                #b0)))
    (dotimes (i 16)
        (setf (pref cursor (:cursor.data.contents i)) (svref data i)
              (pref cursor (:cursor.mask.contents i)) (svref mask i)))
    (setq *horizontal-ps-cursor* cursor)))

(def-ccl-pointers top-ps ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(7 2)))
        (data #(#b0000000000000000
                #b0011111111111100
                #b0000000000000000
                #b0011111111111100
                #b0000000100000000
                #b0000000100000000
                #b0000011111000000
                #b0000001110000000
                #b0000000100000000
                #b0000000000000000
                #b0
                #b0
                #b0
                #b0
                #b0
                #b0
                ))
        (mask #(#b0011111111111100
                #b0011111111111100
                #b0011111111111100
                #b0011111111111100
                #b0011111111111100
                #b0000001110000000
                #b0000111111100000
                #b0000011111000000
                #b0000001110000000
                #b0000000100000000
                #b0
                #b0
                #b0
                #b0
                #b0
                #b0)))
    (dotimes (i 16)
        (setf (pref cursor (:cursor.data.contents i)) (svref data i)
              (pref cursor (:cursor.mask.contents i)) (svref mask i)))
     (setq *top-ps-cursor* cursor)))

(def-ccl-pointers bottom-ps ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(7 7)))
        (data #(#b00000000000000000
                #b00000000100000000
                #b00000001110000000
                #b00000011111000000
                #b00000000100000000
                #b00000000100000000
                #b00111111111111100
                #b00000000000000000
                #b00111111111111100
                #b00000000000000000
                #b0
                #b0
                #b0
                #b0
                #b0
                #b0
                ))
        (mask #(#b0000001110000000
                #b0000011111000000
                #b0000111111100000
                #b0001111111110000
                #b0000001110000000
                #b0111111111111100
                #b0111111111111100
                #b0111111111111100
                #b0111111111111100
                #b0111111111111100
                #b0
                #b0
                #b0
                #b0
                #b0
                #b0)))
    (dotimes (i 16)
        (setf (pref cursor (:cursor.data.contents i)) (svref data i)
              (pref cursor (:cursor.mask.contents i)) (svref mask i)))
     (setq *bottom-ps-cursor* cursor)))

(def-ccl-pointers left-ps ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(2 7)))
        (data #(#b0
                #b0101000000000000
                #b0101000000000000
                #b0101000000000000
                #b0101000000000000
                #b0101001000000000
                #b0101001100000000
                #b0101111110000000
                #b0101001100000000
                #b0101001000000000
                #b0101000000000000
                #b0101000000000000
                #b0101000000000000
                #b0101000000000000
                #b0
                #b0
                ))
        (mask #(#b-100000000000
                #b-100000000000
                #b-100000000000
                #b-11000000000
                #b-10100000000
                #b-10010000000
                #b-1000000
                #b-1000000
                #b-1000000
                #b-10010000000
                #b-10100000000
                #b-11000000000
                #b-100000000000
                #b-100000000000
                #b-100000000000
                #b0)))
    (dotimes (i 16)
        (setf (pref cursor (:cursor.data.contents i)) (svref data i)
              (pref cursor (:cursor.mask.contents i)) (svref mask i)))
     (setq *left-ps-cursor* cursor)))

(def-ccl-pointers right-ps ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(7 7)))
        (data #(#b0
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0001001010000000
                #b0011001010000000
                #b0111111010000000
                #b0011001010000000
                #b0001001010000000
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0000001010000000
                #b0
                #b0
                ))
        (mask #(#b0000011111000000
                #b0000011111000000
                #b0001011111000000
                #b0011011111000000
                #b0111011111000000
                #b-1000000
                #b-1000000
                #b-1000000
                #b0111011111000000
                #b0011011111000000
                #b0001011111000000
                #b0000011111000000
                #b0000011111000000
                #b0000011111000000
                #b0000011111000000
                #b0)))
    (dotimes (i 16)
        (setf (pref cursor (:cursor.data.contents i)) (svref data i)
              (pref cursor (:cursor.mask.contents i)) (svref mask i)))
     (setq *right-ps-cursor* cursor)))

(defvar *gc-cursor* *arrow-cursor*)

;; the kernel needs this - make this one a pointer not a handle
(def-ccl-pointers gc-curs ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(0 0)))
        (data #(#x0000 
                #x0000
                #x0000 
                #b0011110000111100
                #b0111111001111110
                #b1100001011000010
                #b1100000011000000
                #b1100111011000000
                #b1100011011000000
                #b1100011011000010
                #b0111111001111110
                #b0011110000111100
                #x0000
                #x0000
                #x0000
                #x0000
                ))
        (mask #(#x0000 #x0000 #X3C3C #x7E7E #xFFFF #xFFFF #xFFFF #xFFFE
	        #xFFFF #xFFFF #xFFFF #x7E7E #x3C3C #x0000 #x0000 #x0000
                )))
    (dotimes (i 16)
      (setf (pref cursor (:cursor.data.contents i)) (svref data i)
            (pref cursor (:cursor.mask.contents i)) (svref mask i)))
    (setq *gc-cursor* cursor))) 

#|  ;; now use :contextual-menu-arrow-cursor
(def-ccl-pointers cm-curs ()
  (let ((cursor (make-record (:cursor :storage :pointer) :hotSpot #@(1 1)))
        (data #(#b0 
                #b0100000000000000 
                #b0110000000000000 
                #b0111000000000000 
                #b0111100000000000 
                #b0111110000000000 
                #b0111111000000000 
                #b0111111101111110 
                #B0111111111111110 
                #b0111110001000010 
                #b0110110001111110 
                #b0100011001000010 
                #b0000011001111110 
                #b0000001101000010 
                #b0000001101111110 
                #b0
                ))
        (mask #(#b-100000000000000 
                #B-10000000000000 
                #b-1000000000000 
                #b-100000000000 
                #b-10000000000 
                #b-1000000000 
                #b-1 
                #b-1 
                #b-1 
                #b-1 
                #b-100000001 
                #b-1000000000001 
                #b-11000000000001 
                #b-111100000000001 
                #b11111111111 
                #b1111111111
                )))
    (dotimes (i 16)
      (setf (pref cursor (:cursor.data.contents i)) (svref data i)
            (pref cursor (:cursor.mask.contents i)) (svref mask i)))
    (setq *contextual-menu-cursor* cursor)))
|#

              
               

#|
(ccl::def-ccl-pointers *italic-i-beam-cursor* ()
  (setq *italic-i-beam-cursor* *i-beam-cursor*))
|#

(defun frec-cursor (frec where)
  ;(push (list frec where) puke)
  (frec-arg frec)
  (let ((pos (frec-point-pos frec where)))
    (unless (eql pos 0) (decf pos))
    (if (italic-buffer-char-p (fr.cursor frec) pos)
      *italic-i-beam-cursor*
      *i-beam-cursor*)))

(defvar *fred-auto-set-keyscript* t) 

;; add a new fred command meta-j which toggles between
;; 1) a click in fred window sets the keyscript to the script of the neighboring font
;; 2) a click in fred window leaves the keyscript unchanged. The font inherits as usual. 
;; the initial behavior is 1 above

#+ignore
(defun update-key-script-from-click (frec pos leading-edge-p)
  (frec-arg frec)
  (when *fred-auto-set-keyscript*
    (let ((buf (fr.cursor frec)))
      (when (and (not (eql pos 0))
                 (or (eql pos (buffer-size buf))
                     (not (char-eolp (buffer-char buf pos))) ; test was bwds here <<
                     (not leading-edge-p)))
        (decf pos))
      (let* ((index (buffer-char-font-index buf pos))
             (ff (buffer-font-index-codes buf index))
             (script (ff-script ff))
             (keyscript (get-key-script)))
        (unless (eql script keyscript)          
          (ccl::set-key-script script)
          (setf (fr.keyscript frec) script))))))

;; from patch ??
(defun update-key-script-from-click (frec pos leading-edge-p)
  (frec-arg frec)  
  (let ((buf (fr.cursor frec)))
    (when (and (not (eql pos 0))
               (or (eql pos (buffer-size buf))
                   (not (char-eolp (buffer-char buf pos))) ; test was bwds here <<
                   (not leading-edge-p)))
      (decf pos))
    (let* ((index (buffer-char-font-index buf pos))
           (ff (buffer-font-index-codes buf index))
           (encoding (ff-encoding ff))
           (keyscript (get-key-script)))
      (if (memq encoding *script-list*)
        (unless (eql encoding keyscript)
          (if *fred-auto-set-keyscript*
            (progn
              (ccl::set-key-script encoding)
              (setf (fr.keyscript frec) encoding))
            (progn
              ;; set font to something that makes sense in keyscript
              (multiple-value-bind (ff ms) (buffer-find-font-in-script buf keyscript)
                (buffer-set-font-codes buf ff ms)))))))))

(defmethod fred-autoscroll-v-p ((fred-mixin t))
  t)

(defmethod fred-autoscroll-h-p ((fred-mixin t))
  t)

(defun fake-mouse ()
  (rlet ((poo :pointer))
    (errchk (#_createevent (%null-ptr) 
             #$keventclassmouse
             #$kMouseTrackingMouseDragged
             1.0d0
             0
             POO))
    (%get-ptr poo)))

(defvar *a-mouse-event*)

(def-ccl-pointers a-mouse ()
  (setq *a-mouse-event* (fake-mouse)))

;if went outside view then fake-mouse-moved to wake up mouse-down-p

(defun fake-mouse-moved ()
  (#_PostEventToQueue (#_GetMainEventQueue) *a-mouse-event* #$kEventPriorityStandard))



;; put these somewhere else - in level-2.lisp
(defmacro %get-local-mouse-position ()
  `(rlet ((point :point))
     (require-trap #_GetMouse point)
     (%get-point point)))

;; also in level-2.lisp
(defmacro %get-global-mouse-position ()  
 `(rlet ((pt :point))
    (require-trap #_GetGlobalMouse pt)
    (%get-point pt)))

  

(defun frec-click (frec where &optional action-proc &rest args)
  (declare (dynamic-extent args))
  (progn ;without-event-processing - twas once woi - bad bad
    (frec-arg frec)
    (let* ((cursor (fr.cursor frec))
           (first-time-p t)
           (blinkers-on (fr.caret-on-p frec))
           (old-h (point-h where))
           (old-v (point-v where))
           (owner (fr.owner frec))
           pos pos-line pos-bol-p sel-pos wordp linep word-beg word-end
           leading-edge-p)
      (declare (ignore-if-unused pos-line))
      (declare (fixnum old-h old-v))
      (ccl::set-buffer-insert-font-index cursor nil)
      (unless (and (< -1 (point-v where) (point-v (fr.size frec)))
                   (< -1 (point-h where) (point-h (fr.size frec))))
        (return-from frec-click nil))
      (unwind-protect
        (progn
          (%frec-turn-off-blinkers frec)
          (frec-update frec)   ; 3/24
          ;this expects line vec up to date - it may not be without above.
          (multiple-value-setq (pos pos-line pos-bol-p leading-edge-p)
            (frec-point-pos frec where))
          (update-key-script-from-click frec pos leading-edge-p)
          (setf (fr.cursor-bol-p frec) pos-bol-p
                (fr.cursor-bol-p-valid frec) t
                (fr.curcpos frec) -1)
          (if (setq wordp (> *multi-click-count* 1))
            (setq linep (> *multi-click-count* 2)))
          ;(setf (fr.cticks frec) (#_tickcount))  ;; nobody uses this?
          (setf (fr.cposn frec) pos)
          (if (shift-key-p)
            (progn
              (multiple-value-bind (b e) (frec-get-sel frec)
                (setq sel-pos (if (and (< pos e)
                                       (or (<= pos b) (<= (%buffer-position cursor) pos)))
                                e b)))
              (when wordp
                (if linep
                  (setq pos (frec-screen-line-start frec pos (if (< pos sel-pos) 0 1)))
                  (multiple-value-bind (b e) (buffer-word-bounds cursor pos)
                    (setq pos (if (< pos sel-pos) b e)))))
              (setq word-beg sel-pos word-end sel-pos))
            (progn
              (cond ((not wordp) (setq sel-pos pos))
                    (linep
                     (setq sel-pos (frec-screen-line-start frec pos 0)
                           pos (frec-screen-line-start frec pos 1)))
                    (t (multiple-value-setq (sel-pos word-end) 
                         (ccl::buffer-double-click-bounds cursor pos))
                       (if sel-pos 
                         (setq  pos word-end)
                         (setq sel-pos pos))))
              (setq word-beg sel-pos word-end pos)))
          (update-cursor)
          (frec-set-sel frec sel-pos pos)  ; added 5/30 before action-proc = fred-update
          ;(frec-update frec)
          (when action-proc (apply action-proc args))
          (loop          
            ;(frec-update frec) ; removed 5/30
            (frec-idle frec)
            (when first-time-p
              ;(setq first-time-p nil)
              (frec-delay-cursor-off frec t))            
            (when (not (#_stilldown))               
              (when action-proc (apply action-proc args))
              (return))
            (if (and (not first-time-p)(eql (%get-local-mouse-position) where)) ;; maybe mouse moved while we were updating              
              (when (not (wait-mouse-up-or-moved))                 
                (when action-proc (apply action-proc args))
                (return)))
            (setq first-time-p nil)
            (let ((delta 1))
              (tagbody                
                again
                ; but now clicks dont nuke selection!!!!!
                ;(when action-proc (apply action-proc args)) ; is always fred-update - 3/24
                (let ((fake nil))
                  (without-interrupts
                   ;(frec-update frec)  ; this is the third call inside this loop?
                   ;(when action-proc (apply action-proc args))  ; or just fred-update of owner  removed 5/30
                   (setq where (%get-local-mouse-position))
                   (let* ((v (point-v where))
                          (h (point-h where)))
                     (declare (fixnum h v))
                     (when (or wordp (neq sel-pos pos)  ; 4/5
                               (> (abs (- h old-h)) 1) 
                               (> (abs (- v  old-v)) 1))                     
                       ;(frec-set-sel frec sel-pos pos)  ;; show sel at old pos
                       ;(when action-proc (apply action-proc args)) ; added 5/30 in lieu of before moving                                           
                       (multiple-value-setq (pos pos-line pos-bol-p leading-edge-p)
                         (frec-point-pos frec where)) ;; now update pos for new mouse                       
                       (update-key-script-from-click frec pos leading-edge-p)                 
                       (when (fred-autoscroll-v-p owner)                   
                         (when (minusp v)
                           (setq fake t)
                           (set-mark (fr.wposm frec) (frec-screen-line-start frec (fr.wposm frec) (- delta))))
                         (when (< (point-v (fr.size frec)) v)
                           (let ((new-start (frec-screen-line-start frec (fr.wposm frec) delta)))
                             (unless (eql new-start (buffer-size cursor))
                               (set-mark (fr.wposm frec) new-start)))
                           (setq fake t)))
                       (when (fred-autoscroll-h-p owner)                   
                         (when (minusp h)
                           (setq fake t)
                           (frec-add-hscroll frec (- (ccl::%buffer-maxwid (fr.cursor frec)))))
                         (when (< (point-h (fr.size frec)) h)
                           (setq fake t)
                           (frec-add-hscroll frec (ccl::%buffer-maxwid (fr.cursor frec)))))))
                   (when wordp
                     (let (b e)
                       (if linep
                         (setq b (frec-screen-line-start frec pos)
                               e (frec-screen-line-start frec pos 1))
                         (multiple-value-setq (b e) (buffer-word-bounds cursor pos)))
                       (if (and (< pos word-end) (<= pos sel-pos))
                         (setq pos (if (< b word-beg) b word-beg) sel-pos word-end)
                         (setq pos (if (< word-end e) e word-end) sel-pos word-beg))))
                   (frec-set-sel frec sel-pos pos)  ;; now show sel at new pos
                   (when action-proc (apply action-proc args))
                   )
                  (when (and fake  (#_stilldown))
                    (when (< delta 5) (incf delta))
                    (when *the-timer* (sleepticks 1))
                    (go again)))))
            ))
        (when blinkers-on (setf (fr.caret-on-p frec) t))))))

(defun frec-set-hscroll (frec hscroll)
   (frec-arg frec)           
   (setf (fr.hscroll frec) (min (max 0 hscroll) #x7fff)))

(defun frec-add-hscroll (frec amount)
    (frec-arg frec)        
    (frec-set-hscroll frec (min (max 0 (+ (fr.hscroll frec) amount)) #x7fff)))

#|
; this should ffing go away!
(defun frec-set-hscroll (frec hscroll)
  (frec-arg frec)
  (unless (and (fixnump hscroll) (eq (%word-to-int hscroll) hscroll))
    (ccl::report-bad-arg hscroll '(integer #x-7fff #x7fff)))
  (setf (fr.hscroll frec) hscroll)
  (let* ((owner (fr.owner frec))
         (hscroll-bar (when (slot-exists-p owner 'hscroll)
                        (slot-value owner 'hscroll))))
    (when hscroll-bar
      (ccl::%set-control-value hscroll-bar
                          hscroll 
                          (if (not (eql 0 hscroll))
                            (frec-hmax frec))))))
|#
#|
; this is damn slow - is there a better way - does it matter?
; not if we only call it when messing with horizontal scroll
; redefined below
(defun frec-hmax (frec)
  (let* ((visible-lines (frec-full-lines frec))
         (buf (fr.cursor frec))
         (ipos (%buffer-position buf))
         (size-1 (- (buffer-size buf) 1))
         (max (point-h (fr.size frec))))
    (dotimes (i visible-lines)
      (let ((epos (buffer-line-end buf ipos)))
        (setq max (max max (%screen-line-hpos frec ipos (or epos (buffer-size buf)))))
        (when (or (not epos)(>= epos size-1)) (return))
        (setq ipos (1+ epos))))
    max))
|#

#|
; not called
(defun frec-vscroll (frec &optional (lines 1))
  (frec-arg frec)
  (set-mark (fr.wposm frec) 
            (frec-screen-line-start 
             frec (%buffer-position (fr.wposm frec)) lines))
  (frec-update frec))
|#

(defun frec-full-lines (frec)
  (without-interrupts  ; added 4/30
   (when (not (frec-up-to-date-p frec))
     (with-focused-view (fr.owner frec)
       (frec-update frec t)))
   (%frec-full-lines frec)))

;Number of fully visible lines.
(defun %frec-full-lines (frec)
  (let ((lineheights (fr.lineheights frec))
        (numlines (fr.numlines frec))
        (screen-height (point-v (fr.size frec)))
        (v 0))
    (declare (fixnum numlines v))
    (dotimes (i numlines)
      (incf v (the fixnum (linevec-ref lineheights i))))
    (if (> v screen-height)
      (1- numlines)
      numlines)))

; This is no longer slow, but it's not supposed to assume
; that the line vector is up-to-date.
; Will probably have to rewrite it.
; The only caller that hasnt assured its up to date is dialog-item-action
; for h-scroll bar
(defun frec-hmax (frec)
  (frec-arg frec)
  (without-interrupts  ; added 4/30
   (when (not (frec-up-to-date-p frec))
     (with-focused-view (fr.owner frec)
       (frec-update frec t)))
   (let* ((numlines (fr.numlines frec))
          (linewidths (fr.linewidths frec))
          (max (point-h (fr.size frec))))
     (dotimes (i numlines)
       (setq max (max max (linevec-ref linewidths i))))
     max)))

(defun frec-screen-line-vpos (frec line-num)
  (frec-arg frec)
  (without-interrupts
   (when (not (frec-up-to-date-p frec))
     (with-focused-view (fr.owner frec)
       (frec-update frec t)))   
   (let ((vpos 0)
         (lineheights (fr.lineheights frec)))
     (dotimes (i (fr.numlines frec) nil)        ; should this return vpos?
       (when (eql i line-num)
         (return (+ vpos (linevec-ref (fr.lineascents frec) i))))
       (incf vpos (linevec-ref lineheights i))))))

; Find the buffer position nearest to point on the screen.
; Assumes display valid.
; Returns four values:
; 1) buffer position of the point
; 2) line number of the point, if it's on screen.
; 3) true if the point is at the beginning of the line.
; 4) leading-edge-p - true if POINT is in the leading edge of a character
(defun frec-point-pos (frec point)
  (frec-arg frec)
  (let* ((h (point-h point))
         (v (point-v point))
         (size (fr.size frec))
         (size-v (point-v size)))
    (cond ((< v 0) (fr.bwin frec))
          ((> v size-v) (- (buffer-size (fr.cursor frec)) (fr.zwin frec)))
          (t (multiple-value-bind (pos line line-length)
                                  (%screen-point-line-pos frec point)
                (if line
                  (multiple-value-bind (char-pos pos-2)
                                       (%screen-char-pos frec pos line-length h line)
                    (values char-pos line (eql pos char-pos) pos-2))
                  pos))))))

; Find the screen line containing the given point.
; Return three values:
; 1) The character position of the beginning of the line
; 2) The line number - Or NIL if out of bounds
; 3) The length of the line
(defun %screen-point-line-pos (frec point)
  (let ((point-v (point-v point))
        (pos (fr.bwin frec))
        (vpos 0)
        (next-vpos)
        (line 0)
        (numlines (fr.numlines frec))
        (linevec (fr.linevec frec))
        line-length
        (lineheights (fr.lineheights frec)))
    (loop
      (when (>= line numlines)
        (return pos))
      (setq next-vpos (+ vpos (linevec-ref lineheights line))
            line-length (linevec-ref linevec line))
      (when (> next-vpos point-v)
        (return (values pos line line-length)))
      (setq vpos next-vpos)
      (incf pos line-length)
      (incf line))))

; Return the position of the character at horizontal offset H in the line
; beginning at POS with LINE-LENGTH characters.
; Second value is leading-edge-p, true if the click was in the
; leading edge of a character
(defun %screen-char-pos (frec pos line-length h &optional (line-num (frec-screen-line-num frec pos)))
  (multiple-value-bind (char-pos leading-edge-p)
                       (%screen-char-pos-internal frec pos line-length h line-num)
    ; This really needs to do something else for bidirectional text
    (if (and (> pos 0) (italic-buffer-char-p (fr.cursor frec) (1- char-pos)))
      (%screen-char-pos-internal frec pos line-length (- h 1) line-num)
      (values char-pos leading-edge-p))))

(defun %screen-char-pos-internal (frec pos line-length h line-num)
 (frec-arg frec)
 (without-interrupts
 (with-font-run-vectors
   (with-foreground-rgb
     (multiple-value-bind (left-margin right-margin) (frec-margins frec pos)
       (let* ((buffer (fr.cursor frec))
              ;(in-pos pos)
              (max-pos (+ pos line-length))
              (pos (require-type pos 'fixnum))
              (font-limit pos)
              (left (screen-line-ends frec pos line-num (- right-margin left-margin)))
              (fr-hpos (+ left (- left-margin (fr.hscroll frec))))
              (hpos fr-hpos)
              (new-hpos 0)
              (chars 0)
              (bytes 0)
              (font-index 0)
              terminator ff ms
              font-starts font-ends font-count)
         (declare (fixnum pos font-limit hpos new-hpos chars bytes terminator buffer-size))
         (declare (ignore-if-unused bytes))
         (when (char-eolp (ccl::buffer-char buffer (1- max-pos)))
           (decf max-pos))
         (multiple-value-setq (font-starts font-ends font-count)
           (compute-font-run-positions buffer pos max-pos (fr.line-right-p frec)))
         (%stack-block ((tp $max-font-run-length))
           (loop
             (when (eql pos font-limit)
               (when (>= font-index font-count)
                 (return
                  (values
                   (if (or (eql 0 font-count)
                           (ff-left-to-right-p ff))
                     max-pos
                     (aref font-starts (1- font-index)))
                   t)))
               (setq pos (aref font-starts font-index)
                     font-limit (aref font-ends font-index))
               (incf font-index)
               (multiple-value-setq (ff ms)(%set-screen-font buffer pos))
               (when (<= h hpos)
                 (return
                  (if (ff-left-to-right-p ff)
                    (values pos t)
                    (values font-limit nil)))))
             (multiple-value-setq (chars bytes terminator)
               (%snarf-buffer-line
                buffer pos tp (- font-limit pos) $max-font-run-length))
             (cond ((eql chars 0)
                    (if (or (null terminator) (char-eolp terminator))
                      (progn
                        (error  "Shouldn't happen ~S" terminator))
                        #|
                        (setf (fr.bmod frec) 0
                              (fr.zmod frec) 0)
                        (frec-update frec t)
                        (return-from %screen-char-pos-internal
                          (%screen-char-pos-internal frec in-pos line-length h line-num)))|#
                      (progn
                        ; got a tab character
                        (setq new-hpos 
                              (+ fr-hpos (frec-next-tab-stop frec pos (- hpos fr-hpos))))
                        (when (> new-hpos h)
                          (return
                           (if (> (- h hpos) (- new-hpos h))
                             (1+ pos)
                             pos)))
                        (setq hpos new-hpos)
                        (incf pos))))
                   (t
                    (setq new-hpos (+ hpos (xtext-width tp chars ff ms)))
                    (when (> new-hpos h)
                      ; Need to handle leading-edge-p to determine where to
                      ; go at direction-change boundaries
                      #+ignore
                      (multiple-value-bind (pos-offset leading-edge-p)
                                           ;; what to do here??
                                           (ccl::pixel-2-char tp 0 (- h hpos) 0 bytes)
                        (unless (eql chars bytes)
                          (setq pos-offset 
                                (ccl::%buffer-bytes->chars buffer pos pos-offset)))
                        (return (values (+ pos pos-offset) leading-edge-p)))
                      (multiple-value-bind (pos-offset leading-edge-p)
                                        (xpixel-2-char tp chars (- h hpos) ff ms)
                        (return (values (+ pos pos-offset) leading-edge-p))))                      
                    (setq hpos new-hpos)
                    (incf pos chars)))))))))))


; this may be silly???
(defun frec-screen-line-start (frec &optional pos (count 0))
  (without-interrupts  ; added 4/30
   (when (fr.wrap-p frec)
     (when (not (frec-up-to-date-p frec)) ; 3/24
       (with-focused-view (fr.owner frec)
         (frec-update frec t))))
   (%frec-screen-line-start frec pos count)))



(defun %frec-screen-line-start (frec &optional pos (count 0))
  (frec-arg frec)
  (unless (fr.wrap-p frec)
    (return-from %frec-screen-line-start
                 (values (buffer-line-start (fr.cursor frec) pos count))))
  (setq pos (buffer-position (fr.cursor frec) pos))
  (when (if (< 0 count)
          (eq pos (buffer-size (fr.cursor frec)))
          (eql 0 pos))
    (return-from %frec-screen-line-start pos))
  (let (line-num)
    (multiple-value-setq (pos line-num) (%bwd-screen-line-start frec pos count))
    (when (> count 0)
      (let* ((numlines (fr.numlines frec))
             (linevec (fr.linevec frec))
             (size (buffer-size (fr.cursor frec))))
        (when line-num
          (loop
            (incf pos (linevec-ref linevec line-num))
            (when (or (>= pos size) (eql 0 (decf count)))
              (return-from %frec-screen-line-start pos))
            (when (eql (incf line-num) numlines)
              (return))))
        (loop
          (incf pos (%compute-screen-line frec pos))
          (when (or (>= pos size) (eql 0 (decf count)))
            (return)))))
    pos))

; Return two values:
; 1) The screen line number of POS or NIL if it is not on screen
; 2) The position of the beginning of that line.
(defun frec-screen-line-num (frec pos)
  (frec-arg frec)
  (let* ((bwin (fr.bwin frec))
         new-bwin
         (zwin (- (buffer-size (fr.buffer frec)) (fr.zwin frec))))
    (when (and (<= bwin pos) (< pos zwin))
      (let ((line 0)
            (linevec (fr.linevec frec))
            (numlines (fr.numlines frec)))
        (loop
          (when (>= line numlines)      ; shouldn't happen
            (return nil))
          (setq new-bwin (+ bwin (linevec-ref linevec line)))
          (when (> new-bwin pos)
            (return (values line bwin)))
          (setq bwin new-bwin)
          (incf line))))))

; Move backward count lines if count is < 0. Otherwise, just move to the beginning
; of the current line.
;
; Returns two values:
; 1) The position of the line start.
; 2) The screen line number of the line start or NIL if its not on screen.
(defun %bwd-screen-line-start (frec pos count)
  (when (> count 0) (setq count 0))
  (loop
    (when (or (>= count -128) (eql 0 pos))
      (return))
    (setq pos (%bwd-screen-line-start frec pos -128)
          count (+ count 128)))
  (when (eql 0 pos)
    (return-from %bwd-screen-line-start
      (values pos
              (when (eql 0 (fr.bwin frec)) 0))))
  (multiple-value-bind (line line-pos) (frec-screen-line-num frec pos)
    (when line
      (setq pos line-pos)
      (let ((linevec (fr.linevec frec)))
        (loop
          (when (eql 0 count)
            (return-from %bwd-screen-line-start (values pos line)))
          (when (eql 0 line)
            (return))
          (incf count)
          (decf line)
          (decf pos (linevec-ref linevec line))))))
  (let ((bwin (fr.bwin frec))
        (zwin (- (buffer-size (fr.cursor frec)) (fr.zwin frec)))
        (buf (fr.cursor frec)))
    (when (< pos bwin) (setq zwin 0))
    (unless (fr.wrap-p frec)
      (loop
        (setq pos (ccl::buffer-backward-find-eol buf  pos))
        (if pos
          (incf pos)
          (setq pos 0))
        (when (or (eql 0 count) (eql 0 pos))
          (return-from %bwd-screen-line-start pos))
        (incf count)
        (when (<= pos zwin)
          ; Can revert to using fr.linevec
          (when (eql pos zwin)
            (decf pos)
            (incf count))
          (return-from %bwd-screen-line-start
            (%bwd-screen-line-start frec pos count)))))
    ; Line wrapped and off-screen. We've got some work to do.
    ; This works by moving back to the previous newline, then
    ; calling %compute-screen-line until we get to the
    ; current pos, and cacheing the line starts in a stack-consed buffer.
    ; Because of the comparison of count to -128 at the top of the
    ; function, we know that this buffer needs to have only 128 entries.
    ; Really, we need a pre-linevec cache in the frec so that we
    ; don't need to do this every time the user scrolls up.
    ; This code will be responsible for warming up that cache, and
    ; frec-update will need to scroll or invalidate it.
    ; For now, we do this computation every time which will make
    ; scrolling up in a large wrapped paragraph very slow.
    (let ((linestarts (make-array 130))
          (line-nums (make-array 130))
          (line 0)                      ; index into linestarts
          (linestarts-full? nil)
          (linevec (fr.linevec frec))
          (count (- count))
          newline-pos line-pos line-length
          line-num
          linevec-line-pos
          )
      (declare (dynamic-extent linestarts line-nums))
      (declare (ignore-if-unused line-num))  ; donkey poo

      (loop                             ; for each #\return before pos
        (let ((pos-before-newline
               (if (and (> pos 0) (char-eolp (buffer-char buf (1- pos)) ))          
                 (1- pos)
                 pos)))
          (setq newline-pos (ccl::buffer-backward-find-eol buf  pos-before-newline)))
        (if newline-pos
          (incf newline-pos)  ; NB  newline-pos is now BEYOND the newline
          (setq newline-pos 0))
        (when (and (eq frec para-frec)
                   (eql newline-pos para-start)
                   (<= pos para-end)
                   (> pos (aref para-linevec 0)))
          (return-from %bwd-screen-line-start (find-pcache-line frec pos count)))
        (setf (linevec-ref linestarts 0) newline-pos
              line-pos newline-pos
              line-num nil)
        (loop                           ; for each line between newline-pos & pos
          ; this is broken - dont do it. breaks when split pane of listener at least
          ; seems to work OK now??? << put back 7/3/96
          (if  (and (< line-pos zwin) (>= line-pos bwin))
            ; Moved into the on-screen region.
            ; Can save some calls to %compute-screen-line
            (progn 
              (unless line-num
                (multiple-value-setq (line-num linevec-line-pos)
                  (frec-screen-line-num frec line-pos))
                (unless (and line-num (eql line-pos linevec-line-pos))
                  (error "Inconsistency. ~s=~s, ~s /= ~s"
                         'line-num line-num line-pos linevec-line-pos)))
              (setq line-length (linevec-ref linevec line-num))
              (setf (linevec-ref line-nums line) line-num)
              (incf line-num))
            (progn
              (setq line-num nil)
              (setq line-length (%compute-screen-line frec line-pos))
              (setf (linevec-ref line-nums line) nil)))
          (incf line-pos line-length)
          (when (>= line-pos pos) (return))
          (when (eql 0 line-length)
            (error "End of buffer before reaching pos"))
          (incf line)
          (when (eql line 128)
            (setq linestarts-full? t
                  line 0))
          (setf (linevec-ref linestarts line) line-pos))
        (when (or linestarts-full? (>= line count))
          (SETF (LINEVEC-REF LINESTARTS (1+ LINE)) LINE-POS
                (linevec-ref line-nums (1+ line)) nil)
          (when (> line 2)
            (setf para-frec frec)
            (setf para-start newline-pos)
            (setf para-end line-pos)
            (SETF PARA-LINES (+ 2 line))
            (dotimes (i (+ 2 line))
              (setf (aref para-linevec i)(aref lineSTARTS i))))
          (let ((idx (- line count)))
            (declare (fixnum idx))
            (when (eql line-pos pos) (incf idx))
            (if (minusp idx)  ;; << mod when = 128 was evil.
              (setq line (mod idx 128))
              (setq line idx))
            ;(when (or (< line 0)(> line 129)) (error "shouldnt happen ~a" line))
            )
          (return-from %bwd-screen-line-start
            (values (linevec-ref linestarts line)
                    (linevec-ref line-nums line))))
        (decf count (1+ line))
        (setq line 0
              pos newline-pos)))))

; Redraw all lines that are within the rectangle specified by topleft & botright
(defun %frec-draw-contents-internal (frec &optional (topleft #@(0 0) tp) (botright #@(32767 32767)))
  (let ((blinkers-on (fr.caret-on-p frec)))
    #-bccl (frec-arg frec)
    (when (not tp)
      (when t ;(eq frec my-frec)
        ; intersection of clip and visrgn
        (multiple-value-setq (topleft botright) (grafport-visible-corners))))
    (unwind-protect
      (progn
        (%frec-turn-off-blinkers frec)
        (let* ((size (fr.size frec))
               (top (max (point-v topleft) 0))
               (left (max (point-h topleft) 0))
               (bottom (min (point-v botright) (point-v size)))
               (right (min (point-h botright) (point-h size))))
          (when  (and (< top bottom) (< left right))
            ; need to normalize topleft & botright to frec dimensions
            (with-macptrs (rgn)
              (unwind-protect
                (let ((rgn2 ccl::*temp-rgn*))            
                  (%setf-macptr rgn (#_NewRgn))
                  (#_GetClip rgn)  ; some of this can go away now - but its cheap
                  (#_SetRectRgn rgn2 left top right bottom)
                  (#_SectRgn rgn rgn2 rgn2)
                  (#_SetClip rgn2)
                  (#_EraseRgn rgn2)                  
                  (#_ValidWindowRgn (wptr (fr.owner frec)) rgn2)
                  (let ((linevec (fr.linevec frec))
                        (lineheights (fr.lineheights frec))
                        (line 0)
                        (vpos 0)
                        (pos (fr.bwin frec))
                        (top (point-v topleft))
                        (bottom (point-v botright))
                        next-vpos
                        (numlines (fr.numlines frec))
                        start-line start-vpos end-line)
                    (loop
                      (when (>= line numlines) (return))
                      (setq next-vpos (+ vpos (linevec-ref lineheights line)))
                      (when (> next-vpos top)
                        (setq start-line line
                              start-vpos vpos
                              vpos next-vpos)
                        (incf line)
                        (return))
                      (incf pos (linevec-ref linevec line))
                      (setq vpos next-vpos)
                      (incf line))
                    (when start-line
                      (loop
                        (when (>= line numlines)
                          (setq end-line (1- numlines))
                          (return))
                        (when (>= vpos bottom)
                          (setq end-line line)
                          (return))
                        (incf vpos (linevec-ref lineheights line))
                        (incf line))                
                      (%redraw-screen-lines frec pos start-line end-line start-vpos)
                      (#_LMSetHiliteMode (ccl::bitclr 7 (the fixnum (#_LMGetHiliteMode))))
                      (#_InvertRgn (fr.selrgn frec))                
                      nil)))
                (unless (%null-ptr-p rgn)
                  (#_SetClip rgn)
                  (#_DisposeRgn rgn)))))))
      (when blinkers-on 
        (screen-caret-on frec)))))

; This is only temporary. Scrolling needs to get quite a it hairier.
; Especially scrolling up.
; no callers ?
#|
(defun frec-screen-lines (frec)
  (fr.numlines (frec-arg frec)))
|#

#|
(defun show-invalrgn ()
  (without-interrupts
   (with-macptrs ((update-rgn (pref (ccl::%getport) :windowRecord.updateRgn)))
     (let ((rgn ccl::*temp-rgn*))
       (#_CopyRgn update-rgn rgn)
       (when (not (#_emptyrgn rgn))
         (#_OffsetRgn :ptr rgn :long (grafport-global-origin))
         (#_InvertRgn rgn)
         (sleep 0.25)
         (#_InvertRgn rgn)
         (sleep 0.25))))))
|#
#|
	Change History (most recent last):
	2	12/29/94	akh	merge with d13
	3	1/2/95	akh	remove bogus dynamic-extent declaration, fixnum terminator
	4	1/5/95	akh	see top of file - fix some selection glitches re newline, etc
  5   1/6/95   akh   remove a paren
|# ;(do not edit past this line!!)
