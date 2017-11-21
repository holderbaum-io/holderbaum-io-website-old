class Player
  # ...
  def level
    @level
  end

  def compute_pvp_score
    @pvp_arcade.score(uid)
  end
  # ...
end
