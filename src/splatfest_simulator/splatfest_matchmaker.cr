require "./matchmaker.cr"
require "./team.cr"

module SplatfestSimulator
  class SplatfestMatchmaker < Matchmaker
    getter knight_teams : Array(Team)
    getter wizard_teams : Array(Team)

    def initialize(knight_teams = DEFAULT_TEAM_COUNT.times.map do
                     Team.new(faction: :knight)
                   end.to_a,
                   wizard_teams = DEFAULT_TEAM_COUNT.times.map do
                     Team.new(faction: :wizard)
                   end.to_a)
      @teams = knight_teams + wizard_teams

      @wizard_teams = wizard_teams.sort_by(&.total_elo).to_a
      @knight_teams = knight_teams.sort_by(&.total_elo).to_a
    end

    def make_match!
      if 2 > (knight_teams.size + wizard_teams.size)
        raise "not enough teams to make a match"
      end

      sides = [knight_teams, wizard_teams].shuffle
      if sides[0].empty?
        sides = [sides[1], sides[0]]
      end

      team_a = sides[0].sample(1).first
      sides[0].delete(team_a)

      opposition = if sides[1].empty?
                     sides[0]
                   else
                     sides[1]
                   end

      close_teams = Array(Team).new(initial_capacity: CLOSE_TEAM_BUCKET)
      close_team_deltas = Array(Int32).new(initial_capacity: CLOSE_TEAM_BUCKET)
      last_swap = Int32::MAX

      opposition.each do |ct|
        my_delta = (team_a.total_elo - ct.total_elo).abs

        if close_team_deltas.size < CLOSE_TEAM_BUCKET
          close_teams << ct
          close_team_deltas << my_delta
          next
        end

        biggest_delta = close_team_deltas.max

        if biggest_delta > my_delta
          target_idx = close_team_deltas.index(biggest_delta)
          raise "couldn't find replacement delta" if target_idx.nil?
          close_teams[target_idx] = ct
          close_team_deltas[target_idx] = my_delta
          last_swap = my_delta
        elsif my_delta > last_swap
          break # found best bucket
        end
      end

      team_b = close_teams.sample(1).first

      opposition.delete(team_b)

      return Match.new([team_a, team_b])
    end
  end
end
