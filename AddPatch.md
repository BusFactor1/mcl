One way to add a patch file to the MCL repository.

# Introduction #

This page assumes that you have [installed Mercurial](http://code.google.com/p/mcl/wiki/MercurialSetup).

# Details #

You may want to start by [cloning](http://mercurial.selenic.com/wiki/Clone) the current mcl code repository into a new mcl directory:

```
$ hg clone https://mcl.googlecode.com/hg/ mcl
```

Change the current directory to the newly created one:

```
$ cd mcl/Patches
```

Copy your _patch.lisp_ to the _Patches_ directory in the local repository, either using drag-and-drop, or from the command line:

```
$ cp /path/to/patch.lisp .
```

Notify Mercurial that you have added the file:

```
$ hg add patch.lisp
```

Next,  [commit](http://mercurial.selenic.com/wiki/Commit) the change:

```
$ hg commit --message "new patch" --user "Your name <user@domain.com>" 
```

Next, [push](http://mercurial.selenic.com/wiki/Push) the changes to the main repository:

```
$ hg push https://username:gcpasswd@mcl.googlecode.com/hg/
```

Substitute the google _username_ and _[gcpasswd](http://code.google.com/hosting/settings)_ with your own. Note that an eventual `@` in the googlecode username should be encoded as `%40` (single %) to distinguish it from the separator between the username and the password.