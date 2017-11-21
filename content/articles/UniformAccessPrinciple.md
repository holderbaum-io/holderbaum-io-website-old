---
title: 'Uniform Access Principle'
date: 2014-09-26

---

A long, long time ago (around 1997) a smart man (Bertrand Meyer) wrote a
profound statement (in the famous book "Object-Oriented Software Construction")
which influenced our current idea of the decent construction of proper objects.

<!--more-->

> All services offered by a module should be available through a uniform
> notation, which does not betray whether they are implemented through storage
> or through computation.
-- [[Meyer97]][meyer97]


The subject of this article shall be the idea behind this principle and its
implications on day to day programming.

## What does this mean?

Well, it can be generalized to a rather short sentence: "A method name should
not talk about the method's implementation". While this implies also the
abstraction from words like `hash` or `array`, we want to focus particularly on
the two evil prefixes `get` and `compute` (and all of their synonyms:
[here][get_synonyms] and [there][compute_synonyms]).

Imagine a simple `Player` object from an arbitrary browser game:

{{< highlight Ruby >}}
{{< file "player_bad.rb" >}}
{{< /highlight >}}

### Getting things

The first thing to notice is the little `get_level` method. That is considered
bad Ruby style and [rubocop][rubocop] justifiably shouts at me. So we should not
use get at all as a prefix - which does make sense since the Ruby paradigm leans
towards expressive and natural methods. In other languages, for example, Java,
it is considered best practice to prefix getters with `get`. You can read about
this in [[Vernon12, page 246]][vernon12]. Vernon thinks that this bad idiom has
its root in the JavaBean specification and plays a considerable part in
non-readable code.

So stripping away the `get` does not harm readability. To the contrary it
removes technical speaking and thus frees the road towards enhanced readability
for the consumer of your objects. Consider these examples:

{{< highlight Ruby >}}
{{< file "player_usage_get.rb" >}}
{{< /highlight >}}

The removal of the `get` prefix actually increased readability. The addition of
the supplementary `current` can contribute to contextualize the value. It
increases the communication what exactly this level is and leads ultimately to
very expressive domain objects.

### Computing stuff

`compute` as a prefix for methods is more subtle. At the very point of writing
it kind of makes sense to use this prefix. After all you are computing something
in the method. It only affects the slightly reduced expressiveness of your
API. The core problem never occurs while writing the method. It also won't occur
while using the interface for the first times.

But it will haunt you as soon as you start to refactor or enhance your domain
implementations. At some point the implementation will change, probably
drastically:

{{< highlight Ruby >}}
{{< file "player_better.rb" >}}
{{< /highlight >}}

Now you have to change all the consumers of your API. If this object is even
exposed from its module or library you will be forced to make an actual minor or
major version bump just to get the renaming done. If the method would have been
called `pvp_score` this change in implementation details would not require any
effort on the consumer side at all.

## Guidelines for application

You don't have to make a lot of effort to apply the Uniform Access Principle.
Basically one question is important whenever you decide about a specific method
name. Ask yourself whether the contained verbs express domain specific
behaviour or technical terms:

For example `project_member.assign_task(project.newest_urgent_task)` contains
the verb assign. But in this case it is a domain related term which makes it
absolutely fine.

As opposed to this, see the example `project.count_tasks`. This is a rather bad
name. Counting of the tasks is not a business operation. And that you are
actually counting tasks instead of caching the number to return the **amount**
is none of the consumers concern. I would go for a different approach. Some
inspirations could be: `project.task_count` or `project.amount_of_tasks`. The
last one seems a bit superfluous compared to the first one, so my favorite is
the short and concise `task_count`.

Well these are just simple examples but I hope it communicates my approach of
naming things well. Always think of the method name in regard to its
communication:

**"Does it communicate domain concepts or implementation details?"**

## Notes on Ruby

In Ruby there is a particular feature which kind of bothers me:
`attr_accessor`. While it seems like a nice and practical idea as seen in the
following code example, it can lead to unpleasant consequences.

{{< highlight Ruby >}}
{{< file "attr.rb" >}}
{{< /highlight >}}

The first thing one could notice is the saved typing of what seems to be
unnecessary boilerplate code. But I see it a bit different. The usage of this
nifty Ruby helper encourages the exposure of internal variables. It begs to
break encapsulation by any means. So it can be seen as a Uniform Access
Principle breakage advocate.

The usage of the classical assignment method also breaks the flow of reading
from a domain perspective and robs the opportunity to tweak arguments of the
call. Consider this modified and streamlined interface:

{{< highlight Ruby >}}
{{< file "attr_better.rb" >}}
{{< /highlight >}}

The modification communicates its purpose more clearly and gives you the
opportunity to encapsulate some nifty details about the creation of emblems.

Furthermore gave this "refactoring" the opportunity to add a subtle call to `dup`
instead of returning the actual object reference. This can be a very good
protection if the returned object is mutable. By returning an identical copy the
consumer has no way to accidentally modify the internal state of the player
instance.

By staying away from `attr_accessor`, `attr_reader` and `attr_writer`, the
architect of an object is initally forced to focus on building a vivid interface
instead of relying on generic and encapsulation breaking variable assignments.

The automated- or meta-programming-approach gets the author in a mindset of just
exposing the internals without reflection whereas the manual approach is more of
a conscious decision lead by the need to express an external domain driven
interface.

## Final Conclusion

As shown by the examples in the first part above, getting rid of technical verbs
from the names of your methods (implementation details) and decoupling names
from changing technical detail can increase the domain expressiveness of your
objects by a large scale.

[meyer97]: https://isbnsearch.org/isbn/0136291554
[vernon12]:https://isbnsearch.org/isbn/9780321834577

[compute_synonyms]: http://www.thesaurus.com/browse/compute
[get_synonyms]: http://www.thesaurus.com/browse/get
[rubocop]: https://github.com/bbatsov/rubocop
