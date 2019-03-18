require "./player.cr"
require "./team.cr"

module SplatfestSimulator
  class Match
    MAX_TEAM_COUNT = 2
    ARENA_SIZE = 2000

    getter team_a : Team
    getter team_b : Team
    getter winner : Symbol

    getter expectation_a : Float64
    getter expectation_b : Float64
    getter total : Float64
    getter score : Float64

    def initialize(teams = MAX_TEAM_COUNT.times.map{Team.new})
      @team_a = teams[0]
      @team_b = teams[1]

      q_a = 10 ** (Float64.new(@team_a.total_elo) / 400)
      q_b = 10 ** (Float64.new(@team_b.total_elo) / 400)

      @expectation_a = q_a / (q_a + q_b)
      @expectation_b = q_b / (q_a + q_b)

      @total = @expectation_a + @expectation_b
      @score = rand(@total)

      if @score > @expectation_b
        @winner = :a
      else
        @winner = :b
      end
    end

    def mirror?
      @team_a.faction == @team_b.faction
    end

    def elo_delta
      (@team_a.total_elo - @team_b.total_elo).abs
    end

    def judge!
      winner_inked = (ARENA_SIZE * @score).to_i64
      loser_inked = ARENA_SIZE - winner_inked

      if team_a.faction != team_b.faction
        winner_clout = winner_inked + 1000
        loser_clout = loser_inked
      else
        winner_clout = 0_i64
        loser_clout = 0_i64
      end

      if :a == winner
        winning_team = team_a
        losing_team = team_b
      else
        winning_team = team_b
        losing_team = team_a
      end

      winning_team.win! winner_clout.to_i64
      losing_team.lose! loser_clout.to_i64
    end
  end
end
