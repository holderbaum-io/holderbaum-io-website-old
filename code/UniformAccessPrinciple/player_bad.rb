class Player
  # ...
  def get_level
    @level
  end

  def compute_pvp_score
    pvp_matches.map(&:score) / pvp_matches.size
  end
  # ...
end
