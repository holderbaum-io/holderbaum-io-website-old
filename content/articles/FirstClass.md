---
title: 'First Class Citizens'
date: 2014-07-06

---

I don't like primitives. They bury intent and force every possible consumer to
gain knowledge about domain specifics, which it should not even care about.

<!--more-->

This can lead to a lot of SRP (Single Responsibility Principle) violations and
horrible [Law of Demeter][demeter] violations (so called "trainwrecks"[^1]).

## But what is a primitive actually?

Well, in general, everything that is bundled into the core of your language is a
primitive. For example Strings, Arrays, Maps or Numbers. They all come with
the language and are the means of combination for algorithms and data
structures.

## These are unsuited as Domain objects?

What makes primitives dangerous is that they are kind of an implementation
detail. Every book and every course about object composition and software
architecture teaches us repeatedly to hide any details of implementation behind
a conceptual interface (e.g. a `Gateway` instead of a concrete SQL connection).

But what does this mean for the modelling of our precious inner domains? It
won't be practical to get rid of all the primitives, I mean, they are needed!
That's why we use them!

Let me give you a very quick and short example:

{{< highlight Ruby >}}
{{< file "user_1.rb" >}}
{{< /highlight >}}

What is the problem with this class. Is there one? Most of the plain arrays
and enumerables you encounter in a domain are screaming for hidden domain
concepts. In this very trivial example, everything looks fine. We are
calculating the total amount of money to pay by simply reducing over the price
of every chosen good.

Now imagine we add a new business decision. Customers which purchase goods for a
value over `$100` should get an automatic `$15` refund. Well, no problem. We
know how to compare numbers.

{{< highlight Ruby >}}
{{< file "customer_2.rb" >}}
{{< /highlight >}}

Halt! We are heading towards a very painful SRP violation and should refactor
right now, when there are fresh tests in place. So, what just happened? The
`Customer` is getting a hell of a lot of new knowledge, but none of it is
actually the business of a customer. He just wants his discount. Additionally,
every new (and surely more complex) rule regarding discount specifics, we have
to modify the `Customer` class. Testing this class will become more
complicated, because we have to deal with an instance of this `Customer`. What
if the constructor gets more compicated? Or the `outstanding_amount_to_pay`
method name changes? We don't want our important tests for discount regulations
to be affected by these trivial changes. So, let us get rid of the primitive as
representation of the chosen goods by a customer.

{{< highlight Ruby >}}
{{< file "customer_with_purchase.rb" >}}
{{< /highlight >}}

Well, that looks better. The `Customer` lost any knowledge about the
implementation details of the list of goods, and we have a place where we
can safely put concepts that are related to this list (for example the amount of
goods or which one is the most expensive).

One could know argue that the discount calculation is even wrong in the
`Purchase` class. There should be the concept of a discount calculator with
different extendable rules --- I would partly agree. But there is a thin line
between careful modelling of domain concepts and unneeded complexity. So I would
let it be like this, but as soon as there is the notion of additional or more
complex discount calculations, I would refactor into something like the
mentioned concept before adding more rules.

## Additional problems with this example

There is another primitive which can lead to problems: the representation of
money, or to be more specific, the representation of Dollars. I will give you a
short snippet out of my ruby console.

~~~
irb(main):015:0> 10.99 + 23.99
=> 34.98
irb(main):021:0> 10.99 + 23.99 + 1.30
=> 36.279999999999994
~~~

The last result should be straight `36.28`. Is my computer broken? No! That is
the problem with floating point numbers. They tend to be imprecise or vague under
certain circumstances. And you would certainly not want your customer to pay
some arbitrary price like `$10.0099`. What would you give him back if he pays
with a `$20` bill?

One solution could be to deal with this problem through replacement of the
primitive (`Double`) by introducing a `Money` class.

{{< highlight Ruby >}}
{{< file "money.rb" >}}
{{< /highlight >}}

Using this class instead of plain numbers leads to the correct value.

~~~
irb(main):056:0> Money.new(10.99) + Money.new(23.99) + Money.new(1.30)
=> #<Money: 36.28>
irb(main):099:0> r == 36.28
=> false
irb(main):100:0> r == Money.new(36.28)
=> true
~~~

Please note my usage of `instance_variable_get` here. You might think "What the
heck is he doing?". I want to encapsulate the implementation of the `Money`
class. By providing access to the actual number instance for the consumers, I
would invite everyone to break encapsulation and just use this number. And since
this call is inside the class itself I am not violating any rules regarding
encapsulation. The only one who knows about this instance variable is the class
itself and it stays this way. Even the inspect is overwritten, so no information
about the implementation leaks.

## Finally, no dogmatism, please!

Until now, this blog post sounds like I would **never** use any
primitives. Please don't get me wrong here. It is very important to not fall
into dogmatism with such rules. What I basically want to say is the following:

> Whenever you are about to introduce a new value by using a primitive, think
> about the meanings of this value.

So all I do is simply stop for a second and think about what I am about to do,
whenever I introduce new concepts to my domain by using primitives. Special care
should be taken when introducing enumerables. Such collections are literally 90%
of the time explicit concepts and should be encapsulated. For strings and
numbers there is no general rule and heuristic. It would be certainly OK to
store the name of a user by utilizing a string. But for an authentication token,
there is a different story. Probably there are validations around which would
fit into the token? So it can be an entity instead of a string.

But these are all very theoretical examples. As long as you stick to the rule of
reflecting about intent and usage before introducing new conceptual values to
your domain, everything will end up fine. Most of the time.

[^1]: `This.is.a.trainwreck()`

[demeter]: https://en.wikipedia.org/wiki/Law_of_Demeter
