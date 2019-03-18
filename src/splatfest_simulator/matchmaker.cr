require "./team.cr"

module SplatfestSimulator
  class Matchmaker
    DEFAULT_TEAM_COUNT = 1000
    CLOSE_TEAM_BUCKET = 10

    getter teams : Array(Team)

    def initialize(given_teams = DEFAULT_TEAM_COUNT.times.map{Team.new}.to_a)
      @teams = given_teams
    end

    def make_match!
      if 2 > @teams.size
        raise "Not enough teams to make a match"
      end

      team_a = @teams.sample(1).first

      close_teams = (@teams - [team_a]).
                    sort_by{|other| (other.total_elo - team_a.total_elo).abs}.
                    first(CLOSE_TEAM_BUCKET)

      team_b = close_teams.sample(1).first

      @teams = @teams - [team_a, team_b]

      return Match.new([team_a, team_b])
    end

    def make_all_matches!
      (@teams.size / 2).times.map{make_match!}.to_a
    end
  end
end
