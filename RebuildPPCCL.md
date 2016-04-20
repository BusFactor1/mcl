How to rebuild PPCCL and place the update in the repository.

# Introduction #

The PPCCL application is a variation of MCL used primarily to recompile its lisp sources. As it is essential for bootstrapping, the PPCCL image in the repository should be regularly rebuilt to keep up with changes to the MCL sources.

The [rmcl-notes](http://mcl.googlecode.com/hg/rmcl-notes.pdf) document in the repository provides valuable information about how to compile and build the PPCCL from the sources.

# Details #

Follow the same steps as listed on the [Building MCL](http://code.google.com/p/mcl/wiki/BuildingMCL) page, but stop before preparing the mcl environment and saving the application. Evaluate:

```
? (save-application "PPCCL")
```

Place the new PPCCL in a fresh clone of the repository. Then run a the pre-checkin script to split out the file resources:

```
$ sh pre-checkin.sh
```

Next,  [commit](http://mercurial.selenic.com/wiki/Commit) the change:

```
$ hg commit --message "PPCCL rebuilt" --user "Your name <user@domain.com>" 
```

Next, [push](http://mercurial.selenic.com/wiki/Push) the changes to the main repository:

```
$ hg push https://username:gcpasswd@mcl.googlecode.com/hg/
```

Substitute the google _username_ and _[gcpasswd](http://code.google.com/hosting/settings)_ with your own. Note that an eventual `@` in the googlecode username should be encoded as `%40` (single %) to distinguish it from the separator between the username and the password.