---
title: "The Dangers of Test Data"
date: 2018-01-11

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

## Pitfall: Existing Names

## Pitfall: Bogus Websites

## Pitfall: Test Data based on Production Data

## Conclusion
