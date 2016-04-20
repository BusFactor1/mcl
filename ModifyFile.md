One way to modify a file in the MCL repository.

# Introduction #

This page assumes that you have [installed Mercurial](http://code.google.com/p/mcl/wiki/MercurialSetup).

# Preparations #

You may want to start by [cloning](http://mercurial.selenic.com/wiki/Clone) the current mcl code repository into a new mcl directory:

```
$ hg clone https://mcl.googlecode.com/hg/ mcl
```

Change the current directory to the newly created one:

```
$ cd mcl
```

Execute the post-checkout in the repository clone:

```
$ sh post-checkout.sh
```

# Submit the Changes #

After modifying the files, follow these steps to upload the changes to the repository.

Eventually notify Mercurial about added files, if any:

```
$ hg add _path/name_.lisp
```

[Commit](http://mercurial.selenic.com/wiki/Commit) the change:

```
$ hg commit --message "Changes" --user "Your name <user@domain.com>" 
```

[Push](http://mercurial.selenic.com/wiki/Push) the changes to the main repository:

```
$ hg push https://username:gcpasswd@mcl.googlecode.com/hg/
```

Substitute the google _username_ and _[gcpasswd](http://code.google.com/hosting/settings)_ with your own. Note that an eventual `@` in the googlecode username should be encoded as `%40` (single %) to distinguish it from the separator between the username and the password.