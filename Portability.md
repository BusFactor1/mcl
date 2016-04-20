This page provides tips and information about how to make your MCL code more portable.

# Introduction #

Using portable libraries in place of MCL-specific interfaces facilitates that your code can be used with other Common Lisp implementations.

# Portable Libraries #

This is a list of various portable libraries that are compatible with MCL, providing a shared interface for MCL and other Common Lisp implementations.

## System Definition ##

<a href='http://common-lisp.net/project/asdf/'>ASDF System Definition Facility</a>

Note: ASDF may expect `user-homedir-pathname` to provide the pathname of the current home directory, while MCL by default provides the directory from which MCL was started. Fix by binding `ccl::*user-homedir-pathname*` to `(ccl::findfolder #$kuserdomain #$kCurrentUserFolderType)`.

## Networking ##

<a href='http://common-lisp.net/project/usocket/'>USocket</a> TCP/IP socket interface.

<a href='http://github.com/lisp/de.setf.amqp#readme'>DE.SETF.AMQP - a client library for the Advanced Message Queueing Protocol (AMQP)</a>

## File System ##

<a href='http://weitz.de/cl-fad/'>CL-FAD</a> pathname library is a  thin layer atop the standard pathname functions.