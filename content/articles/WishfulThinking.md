---
title: 'Wishful Thinking'
date: 2014-06-09

---

To me, one of the toughest challenges of creating software is dealing with
different levels of abstraction and detail. This mixture of abstraction-layers
can lead to harder understandability and difficultly maintainable code.

<!--more-->

In April 1984, Harold Abelson and Gerald Jay Sussman coined with the amazing
book [Structure and Interpretation of Computer Programs, short SICP][sicp] an
interesting term to tackle exactly this problem: [Wishful Thinking][wish].

The idea is quite simple: write your algorithm with methods that don't exist
(yet) but read very well and do this until you reach the lowest layer of
abstraction. Let's look at a short code example of a use case from a fictional
monster fighting browser game:

{{< highlight Ruby >}}
class OrderMonsterToArena < UseCase
  Input = Bound.required(
                         :defied_keeper_id,
                         :competing_monster_id
                        )
  Denied = Bound.new
  Success = Bound.new(:fight_starts_at)

  def initialize(input)
    @defied_keeper_id = input.defied_keeper_id
    @competing_monster_id = input.competing_monster_id
  end

  def call
    return Denied.new if !challenge_allowed?
    return Denied.new if !monster_obeys?

    Success.new(:fight_starts_at => scheduled_time)
  end

  private
  # ...
end
{{< /highlight >}}

If you read the central call method, there is no detailed knowledge needed or
present regarding the usage, retrieval or storage of entities. Also, no direct
entities can be spotted. Instead, the code forms an abstract Domain Specific
Language.

You can note further that none of these methods are actually implemented. I
made them up by (wishfully) thinking "How would I name this method if I could
name it anything?"

To get this code to work, you can reapply this process of wishful thinking to
the individual methods:

{{< highlight Ruby >}}
class OrderMonsterToArena < UseCase
  # ...

  private
  def challenge_allowed?
    keeper.has_matching_level_for? defied_keeper
  end

  def monster_obeys?
    competing_monster.obeys_keeper?
  end

  def scheduled_time
    scheduled_fight.start_time
  end

  # ...
end
{{< /highlight >}}

In this step, the newly formed layer consists (seemingly) of nothing but
different entities and their high-level domain methods. All the structural
details of saving and retrieval are still hidden. The appliance of the wished
for method led to the actual instances of our existing domain objects, the
entities.

But how do we retrieve them? And more importantly, how are they saved to our
abstraction of the persistence layer? Well, I think you can guess the answer:
"Wishful Thinking".

{{< highlight Ruby >}}
class OrderMonsterToArena < UseCase
  # ...

  def keeper
    keeper_register.current_keeper
  end

  def defied_keeper
    @defied_keeper ||=
      keeper_register.get(@defied_keeper_id)
  end

  def competing_monster
    @monster ||=
      monster_index.get(@competing_monster_id)
  end

  def monster_index
    @monster_index ||=
      monster_index_register.get_for(keeper)
  end

  def scheduled_fight
    @scheduled_fight ||=
      fight_schedule.add(
                         keeper,
                         defied_keeper,
                         competing_monster
                        )
  end

end
{{< /highlight >}}

This step forms the base layer of this usecase. The next step would be to
enhance the used service-classes with the needed interfaces, if they don't
provide it already. I found it very interesting that a clear, layered
structure evolved naturally by this approach. Every method can be easily
modified without interfering too much with the depending layer. As an abstract
graphical representation, this simple use case could be seen as follows:

{{< figure src="wishful.png" class="small" alt="Layer structure of OrderMonsterToArena" >}}

This perspective reveals an interesting pattern. Note how all the dependencies
point away from the use case class - this allows for even drastic changes to my
use case without interfering with my inner entities and services. Also, the
entities have no dependencies at all. They are self-contained and as such very
protected from interface changes.

## Sidenote about Ordering of Methods

An additional topic relates to this concept of structuring complexity. In which
order should one present the methods of different abstractions? A nice approach
is to group them by their conceptual level. As in the given examples above, the
three groups of methods make sense in the given context. While inspecting such a
class, the reader can dive into the concrete implementations if they want to, or
just stay at the semantic level. When done correctly, every group of methods
will be readable and understandable, without the knowledge of the deeper
underlying concepts.

Another approach is ordering by appearance. Here you would mix up the different
layers, and always put a method under the method in which it was first
used. This ordering of methods is proposed by Robert C. Martin in his
[Clean Code][cleancode] book.

I am not quite sure which one of these orderings leads to better understanding,
so I won't give a definite answer. My current tendency leans towards the first
approach, since it does not mix up the different means of abstraction. I like
this.

## Conclusion

By programming against (probably not yet existing) interfaces one can assure
that these interfaces yield the best possible usability. This approach also
produces a nice grouping of the different abstraction layers inside of a class
and almost automatically takes care of the dependency directions inside of your
classes.

It took me some time to practice this style of thinking, but the reward is
well worth the effort. The overall readability of your code will
improve which creates better maintainability as well as one or two
appreciative comments from your colleagues.

[sicp]: http://mitpress.mit.edu/sicp/full-text/book/book.html
[wish]: http://mitpress.mit.edu/sicp/full-text/sicp/book/node28.html
[cleancode]: http://openisbn.com/isbn/0132350882/
