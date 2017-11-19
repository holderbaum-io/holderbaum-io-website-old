---
title: "Readable Tests"
date: 2014-06-22

---

TDD - especially Unit Testing - has evolved to a known and accepted paradigm in
software development.  But nevertheless, the test-first approach behind TDD can
quickly lead to brittle test code which is hard to understand and to maintain.

<!--more-->

**How can this problem be solved?** I want to present a small set
of heuristics and practices I apply day by day to tackle this situation.

## Test Structure

You need a certain structure to achieve a consistent appearance between all your
test cases. Luckily, an intelligent man[^1] has already found a nice rule for
structuring: **Triple A**. This means that you should generally divide your
respective test cases in three distinct sections --- each of which can be
described as follows:

**Arrange** The first lines of you test case should be used to bring the SUT
(System under Test) in the state you need it to be examined. It is basically
your initialization.

**Act** Central to a test is the act part. You should execute the intended
operation in a very prominent way which is critical to display the actual
purpose of your test case.

**Assert** The finishing of the test case is the semantic assertion. The rule of
thumb is that every test case should contain one and only one semantic
assertion. This does not mean one physical, though. A quick example might speak
for itself:

{{< highlight Ruby >}}
{{< file "stack_spec.rb" >}}
{{< /highlight >}}

You increase the readability and understandability of your tests a lot by
sticking to this structure. It eliminates a lot of surprises for the dear
reader.

## Build Groups

Modern test frameworks embrace the building of grouped tests. These groups
should serve a specific context in which the contained tests are to be
executed. A very common mistake is the chosen subject for such a
contextual group. I don't want to be dogmatic but in most of the cases you
should not build groups for specific methods of your SUT. The whole purpose of
groups is to remove setup duplication.

Let's stick with the stack example:

{{< highlight Ruby >}}
{{< file "stack2_spec.rb" >}}
{{< /highlight >}}

It can be clearly seen that the grouping led to a natural growth of the
functionality. By starting out with an empty stack, there was no need to
implement an actual data container. Also, before a `pop` was needed, the `push`
could be added and could be verified just by the `empty?` predicate.

Through grouping by setup and thereby reusing the act-semantics, changes to the
SUT won't be as drastic as they could be. Very often just a few places have to
be changed to adapt the tests to an interface-related refactoring.

## Reveal Intentions

A very important part of building software is the presentation of your actual
intentions to the reader of your code. With increasingly complex domains this
task tends to get even harder. How is it possible to break down complexity into
manageable subtasks? Well, there is one very simple approach which leans in the
direction of [Wishful Thinking][wishful]. Try to build a custom test DSL
(Domain Specific Language) very early in your development cycle. The best way
to do so is by starting with the usage of the DSL and delivering the
implementation while you are writing the test:

{{< highlight Ruby >}}
{{< file "dsl_spec.rb" >}}
{{< /highlight >}}

Now imagine the same test without the freshly generated DSL methods
`register_customer` and `assert_success_of_last_call`. Even for such a simple
case, it would be very tricky for a future reader to actually grasp the
semantic content of your test. This single layer of abstraction directly
decouples your implementation from the logical test.

An additional trick to achieve more readable tests is **assert first**. Just as
you write your tests before your actual code to ensure better design, you
can write your actual assertion before starting with the test. When I tried to
write the most simple working test for my use case above, I simply wrote the
made up name of a nice assertion. I want it to just be successful. And then I
forged some arrangements and actings to stimulate the use case. I highly
recommend to tryout the **assert first** approach in combination with a more
semantic high-level DSL on your next project. You will be surprised!

## Become Independent (manage dependencies)

The good old topic of coupling and dependencies. A test is inherently coupled to
the implementation that is tested. There is no real way around the fact that
there needs to be a defined interface that gets called by your test.

So, after establishing this fact, what are we going to do about it? As mentioned
in [ATDD By Example][ATDD] by Markus Gärtner, the key is to
reduce all dependencies to very local choke points - or as he calls it: Needle
Eyes[^2].

So, instead of directly referring to the methods of your SUT in your test
method, the abstract test DSL encapsulates all your calls and stores this
information thereafter in one point (its implementation).

Additionally, there is the topic of method names in test descriptions. Don't do
it. I personally don't see this as a heuristic but as a rule! Whenever you are
using a method name as part of the test's description, and then calling
this method in the tests itself you are clearly missing an opportunity to
explain the details of what is really being tested. In addition to this,
you are coupling your test structure (!) to methods of your SUT. Every
refactoring that will change your interface will be hard to handle with such a
suite of tests.

So, always stick to the previously mentioned rules for grouping and stay away
from method names in tests. You are testing concepts, or messages, not method
calls.

## Think about "Future-You"

When I write tests, I try to keep in mind "Future-Me" and his job to maintain
"Past-Me's" tests. I know, anticipating change is something where you can go
very wrong but there are some general rules of thumb to increase maintainability
of tests:

**Stay abstract in your test's description** If you are about to test the
behaviour of a list-like object with only one member, don't write the literal
number one in your test or group description. The next change will be painful
otherwise (and think of the missed opportunities, as mentioned above). Instead
try to describe your state in the tests more abstractly, e.g. "barely filled"
vs. "with one element".

**Anticipate change** Whenever I write some magic numbers in a test, I try to
think about them as possible introduction points for changes to the
requirements. One solution could be extraction to variables or methods that will
simplify the later change and give you also more readable tests as an additional
reward.

As example, we can take a look at the first stack spec:

{{< highlight Ruby >}}
{{< file "stack3_spec.rb" >}}
{{< /highlight >}}

The size of the stack is a rather trivial example, but I makes the point. By
extracting such static values, changes will be a lot simpler in the future.

[^1]: Ward Cunningham:   [ArrangeActAssert](http://c2.com/cgi/wiki?ArrangeActAssert)
[^2]: [ATDD By Example, Markus Gärtner, 2012][ATDD], Page 124

[wishful]: /posts/2014-06-09-wishful/
[ATDD]: http://www.openisbn.com/isbn/9780321784155/
