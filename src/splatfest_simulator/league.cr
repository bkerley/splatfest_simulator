require "./player.cr"

module SplatfestSimulator
  class League
    getter players : Array(Player)

    def initialize(@count = 1_000, @player_class = Player)
      @players = @count.times.map{@player_class.new}.to_a
    end

    def average_elo
      @players.map(&.elo).sum / @players.count
    end
  end
end
