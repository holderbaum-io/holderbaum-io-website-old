class Player
  attr_accessor :emblem

  # ...
end

# ...

emblem = Emblem.new(
                    Emblem::Color::RED,
                    Emblem::Color::BLACK,
                    Emblem::Icon::BLADE,
                    'Foo Clan'
                   )

player.emblem = emblem
player.emblem.equal?(emblem) # => true
