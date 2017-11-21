class Player
  # ...
  def specify_emblem(fg_color, bg_color, icon, name)
    @emblem = Emblem.new(fg_color, bg_color, icon, name)
  end

  def emblem
    @emblem.dup
  end
  # ...
end

# ...

player.specify_emblem(
                      Emblem::Color::RED,
                      Emblem::Color::BLACK,
                      Emblem::Icon::BLADE,
                      'Foo Clan'
                     )
