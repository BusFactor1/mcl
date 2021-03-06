(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:IORemoteConfigDirectory.h"
; at Sunday July 2,2006 7:29:44 pm.
; 
;  * Copyright (c) 1998-2002 Apple Computer, Inc. All rights reserved.
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
; #ifndef __IOREMOTECONFIGDIRECTORY_H__
; #define __IOREMOTECONFIGDIRECTORY_H__

(require-interface "libkern/c++/OSObject")

(require-interface "IOKit/IOReturn")

(require-interface "IOKit/firewire/IOFireWireFamilyCommon")

(require-interface "IOKit/firewire/IOConfigDirectory")

(require-interface "IOFireWireROMCache")

#|class OSString;
|#

#|class OSIterator;
|#

#|class IOFireWireDevice;
|#
; ! @class IORemoteConfigDirectory
; 
#|
 confused about CLASS IORemoteConfigDirectory #\: public IOConfigDirectory #\{ OSDeclareDefaultStructors #\( IORemoteConfigDirectory #\) #\; protected #\: IOFireWireROMCache * fROM #\;;  Our cache of the ROM
; ! @struct ExpansionData
;     @discussion This structure will be used to expand the capablilties of the class in the future.
;     
 struct ExpansionData #\{ #\} #\;
; ! @var reserved
;     Reserved for future use.  (Internal use only)  
 ExpansionData * reserved #\; virtual bool initWithOwnerOffset #\( IOFireWireROMCache * rom #\, int start #\, int type #\) #\; virtual void free #\( #\) #\; virtual const UInt32 * getBase #\( #\) #\; virtual IOConfigDirectory * getSubDir #\( int start #\, int type #\) #\; public #\: static IOConfigDirectory * withOwnerOffset #\( IOFireWireROMCache * rom #\, int start #\, int type #\) #\;
; !
;         @function update
;         makes sure that the ROM has at least the specified capacity,
;         and that the ROM is uptodate from its start to at least the
;         specified quadlet offset.
;         @result kIOReturnSuccess if the specified offset is now
;         accessable at romBase[offset].
;     
 virtual IOReturn update #\( UInt32 offset #\, const UInt32 * &romBase #\) #\; protected #\: virtual const UInt32 * lockData #\( void #\) #\; virtual void unlockData #\( void #\) #\; virtual IOReturn updateROMCache #\( UInt32 offset #\, UInt32 length #\) #\; virtual IOReturn checkROMState #\( void #\) #\; private #\: OSMetaClassDeclareReservedUnused #\( IORemoteConfigDirectory #\, 0 #\) #\; OSMetaClassDeclareReservedUnused #\( IORemoteConfigDirectory #\, 1 #\) #\; OSMetaClassDeclareReservedUnused #\( IORemoteConfigDirectory #\, 2 #\) #\;
|#

; #endif /* __IOREMOTECONFIGDIRECTORY_H__ */


(provide-interface "IORemoteConfigDirectory")