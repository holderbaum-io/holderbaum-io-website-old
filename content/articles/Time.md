---
title: "It's Time"
date: 2014-07-13

---

It is time. For what you ask? It is time to make Unit Tests simpler. To get rid
of one of the perpetrators who's making it hard to write simple tests.

<!--more-->

## What is the current Time?

By referring to the computers internal representation of what is known as the
current time, a very tight coupling is formed. And I am not talking about
physical dependencies on the time API of your programming language. I am talking
about an inherent and semantic dependency on a transient state.

As soon as some logic is dependant on the physical flow of time you are
compelled to fake system behaviour just to make the respective call to your
SUT (System Under Test) repeatable.

So in this context I see the current time as a new dimension to the already
complex state space of the thing you are about to test. And a new dimensions
can be roughly translated to: **A hell of a lot more to test.**

## And why can it hurt?

As said before the state space of your unit increases dramatically by
introducing a dependency upon a transient state. What's even worse is the fact
that you are in general not in control of this state.

Let the examples speak.

{{< highlight Ruby >}}
{{< file "counter_example.rb" >}}
{{< /highlight >}}

We have some vouchers for entrance to a theme park. Regular vouchers give
immediate access. Sometimes there are also discount offerings, but these are
only useable 48 hours or more after buying. One can imagine classical unit
tests for this service.

{{< highlight Ruby >}}
{{< file "counter_example_spec.rb" >}}
{{< /highlight >}}

This innocent piece of test code bears several shady practices.

For a start: I'm forced to lie (as the writer). The second and third `describe`
blocks are talking about the time as if it has passed on (`"after ... amount of
time"`). But it has not. Instead I am changing the purchase time of the vouchers
that are inspected. That does not really fit. And changing the name of the block
to a reflection of purchasing vouchers in the past would drastically reduce
communications of intent.


From another perspective, I am introducing great risk of hitting an edge case
resulting in a flapping test. What if this test takes more than a second on
weaker systems? Probably this will only happen occasionally, when the
developer's machine is occupied by heavier tasks, causing a lot of confusion and
nasty testing bugs in several projects I have actively worked on in the past.

## Another perspective on Time


If you think of unit tests as encapsulated and segregated from infrastructure
and external (often slow) dependencies, you gain an additional perspective on
the usage of the current time. So, what is dependent infrastructure? I see it as
everything you explicitly need to call the user space API of your underlying
Kernel for:

For example file and network I/O or timing operations.

These dependencies are hard to change and you certainly don't want them lurking
around in your business code or your domain.

## And now?

So, what is to be done? As always when you are confronted with intermingled
dependencies **Inversion of Control** by utilizing **Dependency Injection** is
your best mate and true stalwart.

Abstract and name the concept you are trying to use instead of it's concrete
implementation. What you want is the value of the current time, and you want to
retrieve it from some sort of timer.

Well, then just say so.

{{< highlight Ruby >}}
{{< file "example.rb" >}}
{{< /highlight >}}

By making the abstract timer role injectable, you gain a lot of flexibility (and
by this readability and verbosity) in your unit test.

{{< highlight Ruby >}}
{{< file "example_spec.rb" >}}
{{< /highlight >}}

The criticized points about the previous design can be solved by this
particularly simple refactoring of the components structure and composition. The
actual usage of the service is not changed, but the possibilities (and
readability) of the new test are vastly improved. If the time-shifting
requirement gets more complicated the explicit calls for time advancement will
pay off.

## What to take away?

I started this post with the intention to talk about time and it's inherent
coupling to transient (and externally changed) state. But I drifted off in a
very generic direction. Is that good? I don't know.

**The key points remain:**

Abstract away all (seemingly minor) dependencies in your units. Then use these
abstractions to drive your tests in a more readable and maintainable way!

Be especially careful with the concept of **current time**. It is always very
good to isolate the concept of advancing time into single conceptual choke
points. As with our example, the unit does not know about conceptual
dependencies to "the time", hence the generic method (`usable?`). Only the tiny
service knows this and encapsulates all time related coupling in its internal
implementation.

By sticking to these rules, better tests and leaner software designs can (and
probably will) be achieved.
