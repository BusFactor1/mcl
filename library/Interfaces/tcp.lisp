(in-package :TRAPS)
; Generated from #P"macintosh-hd:hd3:CInterface Translator:Source Interfaces:tcp.h"
; at Sunday July 2,2006 7:32:04 pm.
; 
;  * Copyright (c) 2000 Apple Computer, Inc. All rights reserved.
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
;  * Copyright (c) 1982, 1986, 1993
;  *	The Regents of the University of California.  All rights reserved.
;  *
;  * Redistribution and use in source and binary forms, with or without
;  * modification, are permitted provided that the following conditions
;  * are met:
;  * 1. Redistributions of source code must retain the above copyright
;  *    notice, this list of conditions and the following disclaimer.
;  * 2. Redistributions in binary form must reproduce the above copyright
;  *    notice, this list of conditions and the following disclaimer in the
;  *    documentation and/or other materials provided with the distribution.
;  * 3. All advertising materials mentioning features or use of this software
;  *    must display the following acknowledgement:
;  *	This product includes software developed by the University of
;  *	California, Berkeley and its contributors.
;  * 4. Neither the name of the University nor the names of its contributors
;  *    may be used to endorse or promote products derived from this software
;  *    without specific prior written permission.
;  *
;  * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
;  * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;  * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
;  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;  * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;  * SUCH DAMAGE.
;  *
;  *	@(#)tcp.h	8.1 (Berkeley) 6/10/93
;  * $FreeBSD: src/sys/netinet/tcp.h,v 1.13.2.3 2001/03/01 22:08:42 jlemon Exp $
;  
; #ifndef _NETINET_TCP_H_
; #define _NETINET_TCP_H_

(require-interface "sys/appleapiopts")

(def-mactype :tcp_seq (find-mactype ':UInt32))

(def-mactype :tcp_cc (find-mactype ':UInt32))
;  connection count per rfc1644 
; #define tcp6_seq	tcp_seq	/* for KAME src sync over BSD*'s */
; #define tcp6hdr		tcphdr	/* for KAME src sync over BSD*'s */
; 
;  * TCP header.
;  * Per RFC 793, September, 1981.
;  
(defrecord tcphdr
   (th_sport :UInt16)
                                                ;  source port 
   (th_dport :UInt16)
                                                ;  destination port 
   (th_seq :UInt32)
                                                ;  sequence number 
   (th_ack :UInt32)
                                                ;  acknowledgement number 

; #if BYTE_ORDER == LITTLE_ENDIAN
#| 
   (th_x2 :UInt32)                              ;(: 4)
                                                ;  (unused) 
                                                ;(th_off : 4)
                                                ;  data offset 
 |#

; #endif


; #if BYTE_ORDER == BIG_ENDIAN
   (th_off :UInt32)                             ;(: 4)
                                                ;  data offset 
                                                ;(th_x2 : 4)
                                                ;  (unused) 

; #endif

   (th_flags :UInt8)
; #define	TH_FIN	0x01
; #define	TH_SYN	0x02
; #define	TH_RST	0x04
; #define	TH_PUSH	0x08
; #define	TH_ACK	0x10
; #define	TH_URG	0x20
; #define	TH_ECE	0x40
; #define	TH_CWR	0x80
; #define	TH_FLAGS	(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG|TH_ECE|TH_CWR)
   (th_win :UInt16)
                                                ;  window 
   (th_sum :UInt16)
                                                ;  checksum 
   (th_urp :UInt16)
                                                ;  urgent pointer 
)
(defconstant $TCPOPT_EOL 0)
; #define	TCPOPT_EOL		0
(defconstant $TCPOPT_NOP 1)
; #define	TCPOPT_NOP		1
(defconstant $TCPOPT_MAXSEG 2)
; #define	TCPOPT_MAXSEG		2
(defconstant $TCPOLEN_MAXSEG 4)
; #define    TCPOLEN_MAXSEG		4
(defconstant $TCPOPT_WINDOW 3)
; #define TCPOPT_WINDOW		3
(defconstant $TCPOLEN_WINDOW 3)
; #define    TCPOLEN_WINDOW		3
(defconstant $TCPOPT_SACK_PERMITTED 4)
; #define TCPOPT_SACK_PERMITTED	4		/* Experimental */
(defconstant $TCPOLEN_SACK_PERMITTED 2)
; #define    TCPOLEN_SACK_PERMITTED	2
(defconstant $TCPOPT_SACK 5)
; #define TCPOPT_SACK		5		/* Experimental */
(defconstant $TCPOPT_TIMESTAMP 8)
; #define TCPOPT_TIMESTAMP	8
(defconstant $TCPOLEN_TIMESTAMP 10)
; #define    TCPOLEN_TIMESTAMP		10
(defconstant $TCPOLEN_TSTAMP_APPA 12)
; #define    TCPOLEN_TSTAMP_APPA		(TCPOLEN_TIMESTAMP+2) /* appendix A */
(defconstant $TCPOPT_TSTAMP_HDR 281474993489930)
; #define    TCPOPT_TSTAMP_HDR		    (TCPOPT_NOP<<24|TCPOPT_NOP<<16|TCPOPT_TIMESTAMP<<8|TCPOLEN_TIMESTAMP)
(defconstant $TCPOPT_CC 11)
; #define	TCPOPT_CC		11		/* CC options: RFC-1644 */
(defconstant $TCPOPT_CCNEW 12)
; #define TCPOPT_CCNEW		12
(defconstant $TCPOPT_CCECHO 13)
; #define TCPOPT_CCECHO		13
(defconstant $TCPOLEN_CC 6)
; #define	   TCPOLEN_CC			6
(defconstant $TCPOLEN_CC_APPA 8)
; #define	   TCPOLEN_CC_APPA		(TCPOLEN_CC+2)
; #define	   TCPOPT_CC_HDR(ccopt)		    (TCPOPT_NOP<<24|TCPOPT_NOP<<16|(ccopt)<<8|TCPOLEN_CC)
; 
;  * Default maximum segment size for TCP.
;  * With an IP MSS of 576, this is 536,
;  * but 512 is probably more convenient.
;  * This should be defined as MIN(512, IP_MSS - sizeof (struct tcpiphdr)).
;  
(defconstant $TCP_MSS 512)
; #define	TCP_MSS	512
; 
;  * Default maximum segment size for TCP6.
;  * With an IP6 MSS of 1280, this is 1220,
;  * but 1024 is probably more convenient. (xxx kazu in doubt)
;  * This should be defined as MIN(1024, IP6_MSS - sizeof (struct tcpip6hdr))
;  
(defconstant $TCP6_MSS 1024)
; #define	TCP6_MSS	1024
(defconstant $TCP_MAXWIN 65535)
; #define	TCP_MAXWIN	65535	/* largest value for (unscaled) window */
(defconstant $TTCP_CLIENT_SND_WND 4096)
; #define	TTCP_CLIENT_SND_WND	4096	/* dflt send window for T/TCP client */
(defconstant $TCP_MAX_WINSHIFT 14)
; #define TCP_MAX_WINSHIFT	14	/* maximum window shift */
(defconstant $TCP_MAXBURST 4)
; #define TCP_MAXBURST		4 	/* maximum segments in a burst */
(defconstant $TCP_MAXHLEN 60)
; #define TCP_MAXHLEN	(0xf<<2)	/* max length of header in bytes */
(defconstant $TCP_MAXOLEN 33)
; #define TCP_MAXOLEN	(TCP_MAXHLEN - sizeof(struct tcphdr))
;  max space left for options 
; 
;  * User-settable options (used with setsockopt).
;  
(defconstant $TCP_NODELAY 1)
; #define	TCP_NODELAY	0x01	/* don't delay send to coalesce packets */
(defconstant $TCP_MAXSEG 2)
; #define	TCP_MAXSEG	0x02	/* set maximum segment size */
(defconstant $TCP_NOPUSH 4)
; #define TCP_NOPUSH	0x04	/* don't push last block of write */
(defconstant $TCP_NOOPT 8)
; #define TCP_NOOPT	0x08	/* don't use TCP options */
(defconstant $TCP_KEEPALIVE 16)
; #define TCP_KEEPALIVE	0x10	/* idle time used when SO_KEEPALIVE is enabled */

; #endif


(provide-interface "tcp")