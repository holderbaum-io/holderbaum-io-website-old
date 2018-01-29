---
title: "The Dangers of Test Data"
date: 2018-01-11
draft: true
---

Generating Test Data is daily business in software development.
Be it to provide realisticly populated views of a demo application
or fake data for an automated unit tests.
Too often though, this task is done without much care
regarding potential implications of poorly chosen data sets.
Let's have a look onto a few common pitfalls
and some easy strategies to avoid those.

## The Issue in a Nutshell

Test Data of every kind is used to interact with the system that has to be tested.
It is probably persisted in a testing database on a staging environment
or written in code of automated tests.
Maybe it is sent via email to a staging application 
or uploaded to a S3 Bucket which pushes data to the test application.

Who guarantees, that such data is never accidentially sent to
or stored in a production system?
This does not necessarily have to happen out of carelessness.
A fact is, mistakes do happen and there is nothing to prevent it.

So, what does all this have to do with Test Data?
In the last decade I observed many occasions
where Test Data found its way into a production system.

The impacts ranged somewhere from
*"some weird text is shown on the live app"* 
over 
*"hundreds of strangers getting password reset emails"*
to
*"customers getting notifications about transactions they never did"*
.
All those occured impacts had the same reason:

> The Test Data contained either partly real data or was based on production data

Let's have a look at some of the issues that made those incidents possible.

## Pitfall: Actual E-Mail Adresses

It is just too tempting to use 
straightforward email addresses for testing purposes like:
`mail@email.com` or `john@test.com`.
And while this might often look like adresses that do not exist,
you can never be sure.
Once your data accidentially reaches a productive system,
maybe a service that sends out emails to newly registered users,
you will find out wether those adresses are actually bogus.

### How to fix this?

IANA specifies a specific standard for exactly that purpose:
[RFC6761](http://www.iana.org/go/rfc6761).
Besides other things, this standard defines a list of domains
that are guaranteed to be valid and resolve to an actual IP.
**But**, they can not be registered by any party.
Those domains are mainly:

* example.org
* example.net
* example.com

Whenever you use one of those domains
as base for your testing email addresses
(e.g. `testuser1@example.org`)
you can be sure that noone receives an accidential email.

## Pitfall: Real Names



## Pitfall: Bogus Websites

## Pitfall: Test Data based on Production Data

## Conclusion
