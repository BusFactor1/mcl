(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:ndr.h"
; at Sunday July 2,2006 7:25:45 pm.
; 
;  * Copyright (c) 2000-2003 Apple Computer, Inc. All rights reserved.
;  *
;  * @APPLE_LICENSE_HEADER_START@
;  * 
;  * The contents of this file constitute Original Code as defined in and
;  * are subject to the Apple Public Source License Version 1.1 (the
;  * "License").  You may not use this file except in compliance with the
;  * License.  Please obtain a copy of the License at
;  * http://www.apple.com/publicsource and read it before using this file.
;  * 
;  * This Original Code and all software distributed under the License are
;  * distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, EITHER
;  * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
;  * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
;  * FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT.  Please see the
;  * License for the specific language governing rights and limitations
;  * under the License.
;  * 
;  * @APPLE_LICENSE_HEADER_END@
;  
; 
;  * @OSF_COPYRIGHT@
;  
; #ifndef _MACH_NDR_H_
; #define _MACH_NDR_H_

(require-interface "stdint")
(defrecord NDR_record_t
   (mig_vers :UInt8)
   (if_vers :UInt8)
   (reserved1 :UInt8)
   (mig_encoding :UInt8)
   (int_rep :UInt8)
   (char_rep :UInt8)
   (float_rep :UInt8)
   (reserved2 :UInt8)
)
; 
;  * MIG supported protocols for Network Data Representation
;  
(defconstant $NDR_PROTOCOL_2_0 0)
; #define  NDR_PROTOCOL_2_0      0
; 
;  * NDR 2.0 format flag type definition and values.
;  
(defconstant $NDR_INT_BIG_ENDIAN 0)
; #define  NDR_INT_BIG_ENDIAN    0
(defconstant $NDR_INT_LITTLE_ENDIAN 1)
; #define  NDR_INT_LITTLE_ENDIAN 1
(defconstant $NDR_FLOAT_IEEE 0)
; #define  NDR_FLOAT_IEEE        0
(defconstant $NDR_FLOAT_VAX 1)
; #define  NDR_FLOAT_VAX         1
(defconstant $NDR_FLOAT_CRAY 2)
; #define  NDR_FLOAT_CRAY        2
(defconstant $NDR_FLOAT_IBM 3)
; #define  NDR_FLOAT_IBM         3
(defconstant $NDR_CHAR_ASCII 0)
; #define  NDR_CHAR_ASCII        0
(defconstant $NDR_CHAR_EBCDIC 1)
; #define  NDR_CHAR_EBCDIC       1
(%define-record :NDR_record (find-record-descriptor ':NDR_record_t))
; #ifndef __NDR_convert__
(defconstant $__NDR_convert__ 1)
; #define __NDR_convert__ 1

; #endif /* __NDR_convert__ */

; #ifndef __NDR_convert__int_rep__
(defconstant $__NDR_convert__int_rep__ 1)
; #define __NDR_convert__int_rep__ 1

; #endif /* __NDR_convert__int_rep__ */

; #ifndef __NDR_convert__char_rep__
(defconstant $__NDR_convert__char_rep__ 0)
; #define __NDR_convert__char_rep__ 0

; #endif /* __NDR_convert__char_rep__ */

; #ifndef __NDR_convert__float_rep__
(defconstant $__NDR_convert__float_rep__ 0)
; #define __NDR_convert__float_rep__ 0

; #endif /* __NDR_convert__float_rep__ */


; #if __NDR_convert__
; #define __NDR_convert__NOOP		do ; while (0)
; #define __NDR_convert__UNKNOWN(s)	__NDR_convert__NOOP
; #define __NDR_convert__SINGLE(a, f, r)	do { r((a), (f)); } while (0)
; #define __NDR_convert__ARRAY(a, f, c, r) 	do { int __i__, __C__ = (c); 	for (__i__ = 0; __i__ < __C__; __i__++) 	r(&(a)[__i__], f); } while (0)
; #define __NDR_convert__2DARRAY(a, f, s, c, r) 	do { int __i__, __C__ = (c), __S__ = (s); 	for (__i__ = 0; __i__ < __C__; __i__++) 	r(&(a)[__i__ * __S__], f, __S__); } while (0)

; #if __NDR_convert__int_rep__

(require-interface "libkern/OSByteOrder")
; #define __NDR_READSWAP_assign(a, rs)	do { *(a) = rs(a); } while (0)
; #define __NDR_READSWAP__uint16_t(a) 	OSReadSwapInt16((void *)a, 0)
; #define __NDR_READSWAP__int16_t(a)	(int16_t)OSReadSwapInt16((void *)a, 0)
; #define __NDR_READSWAP__uint32_t(a) 	OSReadSwapInt32((void *)a, 0)
; #define __NDR_READSWAP__int32_t(a)	(int32_t)OSReadSwapInt32((void *)a, 0)
; #define __NDR_READSWAP__uint64_t(a)	OSReadSwapInt64((void *)a, 0)
; #define __NDR_READSWAP__int64_t(a)	(int64_t)OSReadSwapInt64((void *)a, 0)
#|
 confused about STATIC __inline__ float __NDR_READSWAP__float #\( float * argp #\) #\{ union #\{ float sv #\; uint32_t ull #\; #\} result #\; result.ull = __NDR_READSWAP__uint32_t #\( #\( uint32_t * #\) argp #\) #\; return result.sv #\;
|#
#|
 confused about STATIC __inline__ double __NDR_READSWAP__double #\( double * argp #\) #\{ union #\{ double sv #\; uint64_t ull #\; #\} result #\; result.ull = __NDR_READSWAP__uint64_t #\( #\( uint64_t * #\) argp #\) #\; return result.sv #\;
|#
; #define __NDR_convert__int_rep__int16_t__defined
; #define __NDR_convert__int_rep__int16_t(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__int16_t)
; #define __NDR_convert__int_rep__uint16_t__defined
; #define __NDR_convert__int_rep__uint16_t(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__uint16_t)
; #define __NDR_convert__int_rep__int32_t__defined
; #define __NDR_convert__int_rep__int32_t(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__int32_t)
; #define __NDR_convert__int_rep__uint32_t__defined
; #define __NDR_convert__int_rep__uint32_t(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__uint32_t)
; #define __NDR_convert__int_rep__int64_t__defined
; #define __NDR_convert__int_rep__int64_t(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__int64_t)
; #define __NDR_convert__int_rep__uint64_t__defined
; #define __NDR_convert__int_rep__uint64_t(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__uint64_t)
; #define __NDR_convert__int_rep__float__defined
; #define __NDR_convert__int_rep__float(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__float)
; #define __NDR_convert__int_rep__double__defined
; #define __NDR_convert__int_rep__double(v,f)			__NDR_READSWAP_assign(v, __NDR_READSWAP__double)
; #define __NDR_convert__int_rep__boolean_t__defined
; #define __NDR_convert__int_rep__boolean_t(v, f)			__NDR_convert__int_rep__int32_t(v,f)
; #define __NDR_convert__int_rep__kern_return_t__defined
; #define __NDR_convert__int_rep__kern_return_t(v,f)		__NDR_convert__int_rep__int32_t(v,f)
; #define __NDR_convert__int_rep__mach_port_name_t__defined
; #define __NDR_convert__int_rep__mach_port_name_t(v,f)		__NDR_convert__int_rep__uint32_t(v,f)
; #define __NDR_convert__int_rep__mach_msg_type_number_t__defined
; #define __NDR_convert__int_rep__mach_msg_type_number_t(v,f) 	__NDR_convert__int_rep__uint32_t(v,f)

; #endif /* __NDR_convert__int_rep__ */


; #if __NDR_convert__char_rep__
#| 
; #warning  NDR character representation conversions not implemented yet!
; #define __NDR_convert__char_rep__char(v,f)	__NDR_convert__NOOP
; #define __NDR_convert__char_rep__string(v,f,l)	__NDR_convert__NOOP
 |#

; #endif /* __NDR_convert__char_rep__ */


; #if __NDR_convert__float_rep__
#| 
; #warning  NDR floating point representation conversions not implemented yet!
; #define __NDR_convert__float_rep__float(v,f)	__NDR_convert__NOOP
; #define __NDR_convert__float_rep__double(v,f)	__NDR_convert__NOOP
 |#

; #endif /* __NDR_convert__float_rep__ */


; #endif /* __NDR_convert__ */


; #endif /* _MACH_NDR_H_ */


(provide-interface "ndr")