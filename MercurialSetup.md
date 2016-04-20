How to set up the [Mercurial](http://mercurial.selenic.com/wiki/) [Source Control Management system](http://en.wikipedia.org/wiki/Revision_control) so you can participate in the development of [MCL](http://mcl.googlecode.com/).

# Installation #

  * [Download Mercurial](http://mercurial.berkwood.com/) and follow the instructions to install it on your system.
  * Check out the [tools](http://mercurial.selenic.com/wiki/OtherTools) to use with Mercurial, including GUI clients.
  * Browse the [Mercurial wiki](http://mercurial.selenic.com/wiki/) for more information.

# Getting Started #

You may want to start by [cloning](http://mercurial.selenic.com/wiki/Clone) the current mcl code repository into a new mcl directory:

```
$ hg clone https://mcl.googlecode.com/hg/ mcl
```

Change the current directory to the newly created one:

```
$ cd mcl
```

Make a modification in the local mcl repository. Optionally use [hg diff](http://mercurial.selenic.com/wiki/Diff) to display the changes. Next, [commit](http://mercurial.selenic.com/wiki/Commit) the change:

```
$ hg commit --message "Describe the change" --user "Your name <user@domain.com>" 
```

Next, [push](http://mercurial.selenic.com/wiki/Push) the changes to the main repository:

```
$ hg push https://username:gcpasswd@mcl.googlecode.com/hg/
```

Substitute the google _username_ and _[gcpasswd](http://code.google.com/hosting/settings)_ with your own. Note that an eventual `@` in the googlecode username should be encoded as `%40` (single %) to distinguish it from the separator between the username and the password.

Next time you want to make a change, you can optionally [pull](http://mercurial.selenic.com/wiki/Pull) the recent changes instead of cloning the main repository:

```
$ hg pull https://mcl.googlecode.com/hg/
```

See the [QuickStart](http://mercurial.selenic.com/wiki/QuickStart) for a brief practical introduction to other Mercurial functionality.

# Default Paths #

For convenience you may **add default paths for the MCL project to the `hgrc` file** (`.hg/hgrc`in your Mercurial repository directory):

```
[paths]
default = https://mcl.googlecode.com/hg
default-push = https://username:gcpasswd@mcl.googlecode.com/hg/
```

**Substitute the _username_ and _[gcpasswd](http://code.google.com/hosting/settings)_ with your own.** Keep in mind that the [gcpassword](http://code.google.com/hosting/settings) is **not the same as your login password.**

Note that an eventual **`@` in the googlecode username should be encoded as `%%40`** (double %) to distinguish it from the separator between the username and the password.

# Setting a Username #

To get a meaningful name associated with your changes, **add your preferred username to the `hgrc` file** (`~/hrgc` or `.hg/hgrc` in your Mercurial repository directory):

```
[ui]
username = First Last <username@gmail.com>
```