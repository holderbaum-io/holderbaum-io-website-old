---
title: "Managing Team Secrets Effectively"
date: 2016-09-15
summary: "How to share secret information among your team members in a secure
and automation friendly fashion."
---

What are shared secrets?
They are basically
all the secret things
you, your team and your servers
have to know.
And most modern web applications
integrate with
different services one way or another.
Could be some databases,
other web services,
or third-party APIs.
Often enough,
you either need credentials,
some token
or a certificate
to establish a trusted connection
to these services.

Handling such secrets
in a working team
and during deployments
can be a challenging
and sometimes even intimidating
task.
We want to explore
some directly applicable techniques
that can help us
to simplify this.

There are several approaches
to handling secrets
in an application.
The oldest one being:
simply having constants
in your source code.

{{< highlight JavaScript >}}
{{< file "exampleConstant.js" >}}
{{< /highlight >}}

While this
immediately solves
the problem of
keeping secret information
in sync between
your team members,
it can not be considered
a secure option.
First of all,
everyone who gets access
to the source code
will also be able
to read your secrets.
Furthermore,
stuff like key-rotation
can become tedious,
since you would have to
change, commit and deploy
your actual source code
to do so.
And besides that,
it becomes hard
to deploy
the same code
to more than
one location
(e.g. staging and production).

An evolved
alternative to this
could be the storage of
secrets in configuration files
which are not
checked into version control:

{{< highlight JavaScript >}}
{{< file "exampleConfig.js" >}}
{{< /highlight >}}

This solves at least
the pending issue
of having clear text secrets
in source code --
but it generates
new challenges.
First of all,
synchronization does not
come for free anymore.
If you change
the mentioned password
your team members
and your deployed services
need to know.
This means,
you need a way
to distribute
this secret file
onto your servers
and to everyone
who will actually deploy.
Besides that,
you have an unencrypted file
on the file system
of your server
which again
contains all your precious secrets.
In addition
you can pretty easily
run into
a lockstep scenario
where you have to
make sure
that you deploy
dependant changes
to the config
and the source code
simultaneously.

To completely eradicate files
for reading secrets
one can make use of
environment variables (see [12factor app][12factor_env]):

{{< highlight JavaScript >}}
{{< file "exampleEnv.js" >}}
{{< /highlight >}}

An approach like this
will keep clear text secrets
away from your committed source code
and away from the file system
of your deployments.
In addition to this,
it gives you
configurable deploys.
This means
that you are able
to deploy
your code to
as much environments
as you want.

But it still
leaves you the burden
of finding a way
to securely set these values
during deployment
and distribute them among
your team.

All three approaches
seem like
a trade-off.
You have to decide between
the ability
to synchronize secrets
after rotating them,
and the safety
of their storage.

This means
we need some kind of
synchronized shared password store
that is encrypted
and can be decrypted
by every team-member individually.
Of course,
without the need for one
well-known shared password.
So before diving into
a concrete example,
let's have a look
at some possible tools
to support our needs.

## A short sidetrack about GPG

[GPG (GNU Privacy Guard)](https://gnupg.org/) is an implementation
of a PKI (Public Key Infrastructure).
You may already have heard of it
in the context of email encryption.
If you create a GPG certificate
it will contain correlating
public and private keys
-- also referred to as "asymmetric crypto".
In addition,
such a certificate
will contain a unique GPG ID
that can be used
to refer to it.
Everything that gets encrypted
with that public key
can only be decrypted
by using
the corresponding private key.

This means,
you can share
your public key with peers
so that they are enabled
to send you secret information
that no one can decrypt
without your
(securely stored and password protected)
private key.

While GPG embodies
more features,
like for example digital signatures,
the described public key encryption
is the important one
for the examples to come.

If you want to
get started with GPG
there is
a good
[beginner tutorial](https://spin.atomicobject.com/2013/09/25/gpg-gnu-privacy-guard/) online.

## Introducing pass

The password manager [pass](https://passwordstore.org/)
on the other hand
is a neat little utility
that basically comprises
a convenient wrapper
around GPG.
It allows
to encrypt secret information
with either one or several
public GPG keys.
This enables
more than one person
to decrypt contained secrets
at the same time.

All these secrets
are stored encrypted
inside of one directory.
This directory
can now easily
be shared
using a version control system.

We will
this utility
in our example application
to establish
an encrypted pool
of secret information
without relying on
shared secrets like
a well-known password.

`pass` itself is
actually quite easy
to acquire.
You can simply
install it
using your
favourite package manager:

{{< highlight bash >}}
{{< file "passInstall.sh" >}}
{{< /highlight >}}

## An example Application

We want to build
a status page
that interactively displays
some statistics about
a certain github user.
To do so,
the username
and an access token is needed.
These are the shared secrets
we will have to take care of.

Everything will be hosted
on a PaaS hoster
to simplify and streamline
as much of the infrastructure
as possible.
PaaS stands for
'Platform as a Service'.
It basically means
that you won't
have to manage
bare metal servers
or virtual machines.
Instead,
deployment occurs
on an application basis.
Scaling,
load balancing
and stuff like e.g. database integration
is taken care of
by the hoster.
One of the simplest
PaaS hoster I know is
[heroku](https://heroku.com/).

There is
a good tutorial
on how to setup
your own
[heroku application](https://devcenter.heroku.com/start).

The simplest possible
JavaScript application
that is deployable on heroku
consists of three files:
the package definition,
the process definition
and the actual server file:

The package description
is mainly needed
to contain a list
of dependencies
so that the heroku app server
can download them
prior to starting:

{{< highlight json >}}
{{< file "package.json" >}}
{{< /highlight >}}

The Procfile defines
the processes
which need to be running
in order for the application
to function.
In this case,
this is just
the server backend:

{{< highlight yaml >}}
{{< file "Procfile" >}}
{{< /highlight >}}

The actual server endpoint
is located
in the `index.js` file
and build on top of `express.js`.
`express` is a pretty common
JavaScript http server framework.
The app is configured
using three environment variables.
Two of these
are the github credentials
used to authenticate
against the github API.
The third
is the HTTP port
on which the application server
will listen on.

{{< highlight JavaScript >}}
{{< file "index.js" >}}
{{< /highlight >}}

Heroku itself deploys using git.
To trigger the deployment
simply push to the heroku origin
created during setup:

{{< highlight bash >}}
{{< file "herokuPush.sh" >}}
{{< /highlight >}}

In principle,
this is all you have to do
to get the application
up an running.
But since we are referring
to two environment variables
for our credentials (`GITHUB_USER` and `GITHUB_API_TOKEN`)
we have to initialize them
prior to startup.

The heroku tool allows us
to explicitly trigger
an application restart
while persistently setting
certain environment variables
from command-line:

{{< highlight bash >}}
{{< file "herokuConfig.sh" >}}
{{< /highlight >}}

This approach is
taking us
into a good direction.
It removes
hard-coded secrets
from any files,
be it source code
or configuration.

But still,
to execute
this configuration command,
I need to
manually type
all needed secrets
into my terminal.
And that is true
for every person
that should be able
to deploy.
Our challenge
is not
completely solved,
yet.

So we need a way
to retrieve
these secret information
automatically.
Let's use `pass`
to build a secret store.

## Using pass for secret values

As mentioned before,
`pass` mainly operates
on a single directory
which we will call
the secret store.
To initialize such a store
you have to set its
path in form
of an environment variable
and then simply
initialize it
by calling `pass`.
We will initialize
the store with
my personal GPG ID only
to further simplify
the example:

{{< highlight bash >}}
{{< file "storeInit.sh" >}}
{{< /highlight >}}

The argument provided
to the `pass init` call
is my GPG ID.
You can pass an arbitrary list
of IDs to
the `init` call.
Every GPG ID
will be able
to decrypt
the contents
of the store.
Now adding values
to the store
is even simpler.
`pass` provides
an `add` command
that can
read from stdin:

{{< highlight bash >}}
{{< file "storeAdd.sh" >}}
{{< /highlight >}}

After adding it
to the secret store
one can easily decrypt it
as long as
the GPG certificate
of the given ID
is yours.
To do so
just utilize
`pass show`.
This command
will print
the decrypted secret
on `stdout` for
easy usage and scriptability.
It can be used like this
to further improve
the deployment configuration call:

{{< highlight bash >}}
{{< file "storeShow.sh" >}}
{{< /highlight >}}

So far
we achieved
having a password store
that is living
in a single directory
and based on flat files
that can be shared
using version control.
The `~/Code/myapp/secrets` dir now looks like this:

{{< highlight bash >}}
{{< file "storeFind.sh" >}}
{{< /highlight >}}

The `*.gpg` files
contain the encrypted secrets
that had been added
previously.
The `.gpg_id` file
contains the list
of GPG IDs
that are used
to encrypt
the contents
of the store.
It is even possible
to use
different `.gpg_id` files
for different subdirectories.
This feature
can enable
different access policies
per directory
(e.g. certain secrets
are only readable
by a part of the team).

Of course,
you don't have
to use
a tool
like `find`
to display
the content
of such a secret store.
You can simply call
`pass ls` for that:

{{< highlight bash >}}
{{< file "storeLs.sh" >}}
{{< /highlight >}}

The previously seen
`pass show` call
can be combined with
the `heroku config:set` call
to deploy
without typing
explicit secrets:

{{< highlight bash >}}
{{< file "herokuConfigWithPass.sh" >}}
{{< /highlight >}}

So far,
we have accomplished
a secret store
only accessible
for a single person.
But the goal was
to be able to
share secrets
inside the team.
That means,
we are not done yet!

## Working with a Team

The example above
operated only with one GPG ID.
This is useful
for a personal project
without an actual team.
When working with teams
we usually talk about
two different
points in time
that have
-- beside other implications --
an impact on security:
**Roll On** and **Roll Off**

## Handling 'Roll On' of a new Team Member

Rolling On means
that an additional person
joins the trusted
circle of team members.
This involves in general
granting certain privileges
to that person
like access to
project secrets
and/or infrastructure.
It is a good thing
to have a
Roll On Security Checklist
on your project
to handle such a scenario.
Nevertheless,
when a person joins,
beside other tasks,
access to secrets
needs to be ensured.
`pass` makes this
no effort at all.

Just get
the new members GPG ID
and Public Key
and call init again
with all IDs
including the new one.
Everything will be
re-encrypted accordingly:

{{< highlight bash >}}
{{< file "teamRollOn.sh" >}}
{{< /highlight >}}

On account
of the secret store access
this is all
there is to be done.
This procedure
can be repeated
every time
a new member joins.
Note, that you
need to have the GPG public key
in your local GPG key ring
in order to be able
to encrypt with it.

This means,
you have to make sure,
that every member of your team
is in possession of
every public key
that is used
inside your team.

## Handling 'Roll Off' of a leaving Team Member

Leaving the team
on the other hand
generates more work.
Changing access
to the secret store
is easy.
Just call `init` again
but leave out the GPG ID
of the leaving member this time.


{{< highlight bash >}}
{{< file "teamRollOff.sh" >}}
{{< /highlight >}}

But this won't
make the secrets
used up until now
magically unknown
to the leaving person.
The only assurance
you get is
that the left member
won't be able to decrypt
secrets from now on
should they get
a hold of
the secret store directory.
The history of the secret store
-- meaning: all previously encrypted secrets --
will still be decryptable for them.

This implies
that the change
of secret information
(like passwords or API tokens)
should be a dedicated step
on your Roll Off Checklist.

But since
you can keep
your secrets
in one dedicated place,
rotating them
after a Roll Off
becomes less
of a challenge.

## Conclusion

We have built
an encrypted secret store
in a single directory.
This directory
can be distributed
amongst your team members
like regular source code,
e.g. by checking it
into version control.
This will
even give us
a versioned secret store.
Because of the nature of pass,
the process of
people joining or leaving the team
becomes as streamlined as possible,
without compromising security.
