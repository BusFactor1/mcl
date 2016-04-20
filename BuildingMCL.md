How to build the MCL application from the repository.

# Introduction #

The [rmcl-notes](http://mcl.googlecode.com/hg/rmcl-notes.pdf) document in the repository provides detailed information about how to compile and build the MCL application from the sources.

_Xcode and Apple's Developer tools are NOT required to build MCL._

# Summary #

To build a new version of MCL:

  1. Download the repository.
  1. Compile the source code.
  1. Build a _ppc-boot_ bootstrapping application.
  1. Load the rest of the compiled sources.
  1. Save the new application.
  1. Gather the distribution.

# Download the Repository #

After [installing Mercurial](http://code.google.com/p/mcl/wiki/MercurialSetup), download a clone of the repository using the Terminal (or your Mercurial GUI of choice):

```
$ hg clone https://mcl.googlecode.com/hg/ mcl 
```

Next, execute the post-checkout in the repository clone:

```
$ cd mcl
$ sh post-checkout.sh
```

# Compile the Sources #

Launch PPCCL (give it plenty of time to start):

```
$ open ./PPCCL
```

In the Listener of PPCCL, optionally evaluate the following to reset eventual preferences:

```
? (dolist (cat *env-categories*)(dolist (spec (cdr cat))(set (first spec) (third spec))))
```

In the Listener of PPCCL, do:

```
? (compile-ccl t)
```

Consider taking a break: Compiling the sources may take some time to complete. There might be several warnings, but it should finish without errors.

# Build the Bootstrapping Image #

In PPCCL do:

```
? (xload-level-0 :force)
```

This creates an application called _ppc-boot_. Note that it is crucial that this step happens <em>after</em> compile-ccl.

Quit the PPCCL application:

```
? (quit)
```

# Run the Bootstrapping Image #

Launch _ppc-boot_ to get a menu and a Listener:

```
$ open ./ppc-boot
```

_If you have problems launching ppc-boot from the Terminal, start it from the Finder by double-clicking the ppc-boot file. Alternatively use `/System/Library/Frameworks/Carbon.framework/Versions/A/Support/LaunchCFMApp  ./ppc-boot` from the Terminal. If ppc-boot still doesn't run, transfer the repository to a another Intel Mac (alternatively a PPC with OSX 10.4 or newer), then open ./PPCCL and rebuild the bootstrapping image before continuing. The current suspicion is that Apple's Developer tools with Xcode 4 is a potential culprit (building a running ppc-boot is verified to succeed on an Intel Mac with OSX 10.6.7 and  Xcode 3.2 yet fails on another Intel Mac with the same OSX version but Xcode 4.0.1)  - please share if you have evidence to the contrary._

Evaluate the following to load the remaining files (you may not be allowed to paste into the ppc-boot Listener, in which case you'll have to type it):

```
? (require "PPC-INIT-CCL")
```

# Save the MCL Application #

To prepare the MCL application, do:

```
? (require "PREPARE-MCL-ENVIRONMENT")
```

Optionally upgrade to the **MCL 6** preview by loading the latest enhancements:

```
? (require "MCL6" #p"ccl:Mods;mcl6")
```

To save the application, do:

```
? (save-application "MCL" :size (ash 1 26))
```

Adjust the size as you see fit. Note that unless you provide a size, save-application will by default allocate about 1GB memory for the application. This may cause MCL to take a very long time to start on computers with insufficient memory.

# Gather the Distribution #

Start the saved application:

```
$ open ./MCL
```

Then evaluate:

```
? (load "gather-distribution")
? (ccl::gather-distribution)
? (quit)
```

After completion, there will be a new folder in the repository clone containing the distribution:

```
$ open .
```



