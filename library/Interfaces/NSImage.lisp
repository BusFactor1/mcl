(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:NSImage.h"
; at Sunday July 2,2006 7:30:50 pm.
; 
; 	NSImage.h
; 	Application Kit
; 	Copyright (c) 1994-2003, Apple Computer, Inc.
; 	All rights reserved.
; 

; #import <Foundation/NSObject.h>

; #import <Foundation/NSGeometry.h>

; #import <Foundation/NSBundle.h>

; #import <AppKit/NSGraphics.h>

; #import <AppKit/NSBitmapImageRep.h>

; #if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2

(defconstant $NSImageLoadStatusCompleted 0)
(defconstant $NSImageLoadStatusCancelled 1)
(defconstant $NSImageLoadStatusInvalidData 2)
(defconstant $NSImageLoadStatusUnexpectedEOF 3)
(defconstant $NSImageLoadStatusReadError 4)
(def-mactype :NSImageLoadStatus (find-mactype ':SINT32))

(defconstant $NSImageCacheDefault 0)            ;  unspecified. use image rep's default

(defconstant $NSImageCacheAlways 1)             ;  always generate a cache when drawing

(defconstant $NSImageCacheBySize 2)             ;  cache if cache size is smaller than original data
;  never cache, always draw direct

(defconstant $NSImageCacheNever 3)
(def-mactype :NSImageCacheMode (find-mactype ':SINT32))

; #endif

#| @INTERFACE 
NSImage : NSObject <NSCopying, NSCoding> {
    
    NSString *_name;
    NSSize _size;
    struct __imageFlags {
	unsigned int scalable:1;
	unsigned int dataRetained:1;
	unsigned int uniqueWindow:1;
	unsigned int sizeWasExplicitlySet:1;
	unsigned int builtIn:1;
	unsigned int needsToExpand:1;
	unsigned int useEPSOnResolutionMismatch:1;
	unsigned int colorMatchPreferred:1;
	unsigned int multipleResolutionMatching:1;
	unsigned int subImage:1;
	unsigned int archiveByName:1;
	unsigned int unboundedCacheDepth:1;
        unsigned int flipped:1;
        unsigned int aliased:1;
	unsigned int dirtied:1;
        unsigned int cacheMode:2;
        unsigned int focusedWhilePrinting:1;
        unsigned int reserved1:14;
    } _flags;
    void *_reps;
    NSColor *_color;
}

+ (id)imageNamed:(NSString *)name;	

- (id)initWithSize:(NSSize)aSize;
- (id)initWithData:(NSData *)data;			
- (id)initWithContentsOfFile:(NSString *)fileName;	
- (id)initWithContentsOfURL:(NSURL *)url;               
- (id)initByReferencingFile:(NSString *)fileName;	
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
- (id)initByReferencingURL:(NSURL *)url;		
#endif
- (id)initWithPasteboard:(NSPasteboard *)pasteboard;

- (void)setSize:(NSSize)aSize;
- (NSSize)size;
- (BOOL)setName:(NSString *)string;
- (NSString *)name;
- (void)setScalesWhenResized:(BOOL)flag;
- (BOOL)scalesWhenResized;
- (void)setDataRetained:(BOOL)flag;
- (BOOL)isDataRetained;
- (void)setCachedSeparately:(BOOL)flag;
- (BOOL)isCachedSeparately;
- (void)setCacheDepthMatchesImageDepth:(BOOL)flag;
- (BOOL)cacheDepthMatchesImageDepth;
- (void)setBackgroundColor:(NSColor *)aColor;
- (NSColor *)backgroundColor;
- (void)setUsesEPSOnResolutionMismatch:(BOOL)flag;
- (BOOL)usesEPSOnResolutionMismatch;
- (void)setPrefersColorMatch:(BOOL)flag;
- (BOOL)prefersColorMatch;
- (void)setMatchesOnMultipleResolution:(BOOL)flag;
- (BOOL)matchesOnMultipleResolution;
- (void)dissolveToPoint:(NSPoint)point fraction:(float)aFloat;
- (void)dissolveToPoint:(NSPoint)point fromRect:(NSRect)rect fraction:(float)aFloat;
- (void)compositeToPoint:(NSPoint)point operation:(NSCompositingOperation)op;
- (void)compositeToPoint:(NSPoint)point fromRect:(NSRect)rect operation:(NSCompositingOperation)op;
- (void)compositeToPoint:(NSPoint)point operation:(NSCompositingOperation)op fraction:(float)delta;
- (void)compositeToPoint:(NSPoint)point fromRect:(NSRect)rect operation:(NSCompositingOperation)op fraction:(float)delta;
- (void)drawAtPoint:(NSPoint)point fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(float)delta;
- (void)drawInRect:(NSRect)rect fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(float)delta;
- (BOOL)drawRepresentation:(NSImageRep *)imageRep inRect:(NSRect)rect;
- (void)recache;
- (NSData *)TIFFRepresentation;
- (NSData *)TIFFRepresentationUsingCompression:(NSTIFFCompression)comp factor:(float)aFloat;

- (NSArray *)representations;
- (void)addRepresentations:(NSArray *)imageReps;
- (void)addRepresentation:(NSImageRep *)imageRep;
- (void)removeRepresentation:(NSImageRep *)imageRep;

- (BOOL)isValid;
- (void)lockFocus;
- (void)lockFocusOnRepresentation:(NSImageRep *)imageRepresentation;
- (void)unlockFocus;

- (NSImageRep *)bestRepresentationForDevice:(NSDictionary *)deviceDescription;

- (void)setDelegate:(id)anObject;
- (id)delegate;


+ (NSArray *)imageUnfilteredFileTypes;
+ (NSArray *)imageUnfilteredPasteboardTypes;
+ (NSArray *)imageFileTypes;
+ (NSArray *)imagePasteboardTypes;

+ (BOOL)canInitWithPasteboard:(NSPasteboard *)pasteboard;

- (void)setFlipped:(BOOL)flag;
- (BOOL)isFlipped;

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
- (void)cancelIncrementalLoad;

-(void)setCacheMode:(NSImageCacheMode)mode;
-(NSImageCacheMode)cacheMode;
#endif

|#
; #ifdef WIN32
#| #|

@interface NSImage (NSWindowsExtensions)
- (id)initWithIconHandle:(void * )icon;
- (id)initWithBitmapHandle:(void * )bitmap;
@end

#endif
|#
 |#
#| @INTERFACE 
NSObject(NSImageDelegate)
- (NSImage *)imageDidNotDraw:(id)sender inRect:(NSRect)aRect;

#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_2
- (void)image:(NSImage*)image willLoadRepresentation:(NSImageRep*)rep;
- (void)image:(NSImage*)image didLoadRepresentationHeader:(NSImageRep*)rep;
- (void)image:(NSImage*)image didLoadPartOfRepresentation:(NSImageRep*)rep withValidRows:(int)rows; 
- (void)image:(NSImage*)image didLoadRepresentation:(NSImageRep*)rep withStatus:(NSImageLoadStatus)status;
#endif
|#
#| @INTERFACE 
NSBundle(NSBundleImageExtension)
- (NSString *)pathForImageResource:(NSString *)name;	
|#

(provide-interface "NSImage")