---
title: 'Specific Assertions'
date: 2016-01-15

---

In the context of automated testing
**assertions** are used
to verify the result
of a specific action.
Modern testing frameworks
provide a multitude
of generic assert methods/functions.

While these assertions are
an essential tool
for crafting automated tests
they very often fail in
expressing test intentions.

<!--more-->

In addition to this
the usage of generic assertions
very often lead to
a reduced maintainability
and a tighter coupling
between the actual tests
and the code under test.

This article will
shed some light on these claims
by inspecting and commenting
some test code snippets
inspired by code of actual projects.

## Testing with Generic Assertions

Below is an excerpt of
a test for a router class
of a web application framework.
It stimulates a router instance
with different URL and inspects
the behaviour of the router
by comparing the result
of the parse call.

{{< highlight Ruby >}}
{{< file "url_spec.rb" >}}
{{< /highlight >}}

Technically, these tests are not unreadable.
Nevertheless imposes the style of coding
some particular issues.

## The Problem of Interface Coupling

Because of the high repetition rate,
the tests have become closely tied
to the interface of the `Router`.

Assume an interface change
like in the following example:

{{< highlight Ruby >}}
Router.parse('/:y/:x', '/foo/bar')
{{< /highlight >}}

Or the result is returned
as a specific DTO
instead of encoding it
by a `hash` or plain `nil`:

{{< highlight Ruby >}}
Router.parse('/:y/:x', '/foo/bar') ==
  Router::ParsedRoute.new(y: 'foo', x: 'bar')

Router.parse('/baz/:x', '/foo/bar') ==
  Router::NoParsedRoute.new
{{< /highlight >}}

When conducting these or
similar refactorings on the API level,
all the tests will break.

## The Problem of reduced Expressiveness

Especially the tests
at the end of the example
lack a certain
amount of expressiveness.
Take the following assertion
as an example:

{{< highlight Ruby >}}
assert_equal(nil,
             Router.new('/bar/:x').parse('/BAZ/foo'))
{{< /highlight >}}

Without the context of the test name
this line does not really
reflect the core concept of the test.

It is not of any interest,
that the call to `parse`
returned an actual `nil` value.
The underlying concept
at the core of this test
is the fact
that the given URL
was not parsable
by the `Router`.

## Moving towards Specific Assertions

Custom and highly test-specific assertions
can be utilized to:

* effectively decouple the tests from
all interface changes and
* increase the expressiveness of the test
to a reasonable level.

Take the following rewritten test
with two custom assertions
as an example:

{{< highlight Ruby >}}
{{< file "url_spec_rewritten.rb" >}}
{{< /highlight >}}

As you can see
the custom built assertions
do increase the readability
of the individual tests.
They also reduce the repetiton
of the actual `Router` interface
to a bare minimum
so that any contract changes
will have a minimum impact
on the tests.

The usage of custom messages
on the internally used
generic assertions
will also help the developers
to get a clearer picture
in case of any failing tests.

## Benefits of Custom Assertions

Even though the above example
is a rather short one,
it reflects some of the benefits
one can get using specific assertions
where appropriate.

The main improvement
compared to the usage of
generic assertions
is the increased expressiveness
of the individual tests.
**Meaning** of the test
and its **implementation**
is fully decoupled.

Because of this decoupling
the developer
gets better
test maintainability for free
since the interface of the System Under Test
is less scattered around.
Ideally, **only** the **specific assertions
interact with** the interface directly.
Direct changes on the interface
will thus have a lesser
impact on the test code.

Another advantage
is the opportunity
to be more explicit
with the assertion messages.
One can freely add
very descriptive error messages
to the individual assertion methods
without repeating them
over and over again
in every test case.
This is especially helpful
if one or more test cases
start to fail
after several code changes,
probably even on different parts
of the systems.
That gives a developer confronted
with a sudden test failure
on the system a clearer view
of the potential origins of that error.
Just compare the difference between
the following two outputs:

{{< highlight Ruby >}}
"Expected /:x/:y to match /foo/22"
# vs
"Expected: {:x => 'foo', :y => 22}, Actual: nil"
{{< /highlight >}}

The difference in readability
-- especially in the context
of several failing tests in a row --
is worth the small effort
of building custom assertions.

Overall, the construction
of custom assertions might
at a first glance
be more upfront work
than sticking to the already present
generic ones.

## Refererences:

The following prior posts
do contain similar topics
around the concepts of
specific assertions:

* [Wishful Thinking](/articles/WishfulThinking/)
* [Readable Tests](/articles/ReadableTests/)
