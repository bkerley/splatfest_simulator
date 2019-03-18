require "./player.cr"

module SplatfestSimulator
  class Team
    MAX_TEAM_SIZE = 4

    getter players : Array(Player)
    getter faction : Symbol
    getter total_elo : Int32

    property streak : Int32
    property clout : Int64
    property wins : Int32
    property losses : Int32

    def initialize(given_players = MAX_TEAM_SIZE.times.map{Player.new}.to_a,
                   @faction = :neutral)
      @players = given_players.map{|p| p}.to_a
      @streak = 0
      @clout = 0
      @wins = 0
      @losses = 0
      @total_elo = @players.map(&.elo).sum
    end

    def win!(clout_change : Int64)
      @wins += 1
      @clout += clout_change
      if @streak > 0
        @streak += 1
      else
        @streak = 1
      end
    end

    def lose!(clout_change : Int64)
      @losses += 1
      @clout += clout_change
      if @streak < 0
        @streak -= 1
      else
        @streak = -1
      end
    end
  end
end
