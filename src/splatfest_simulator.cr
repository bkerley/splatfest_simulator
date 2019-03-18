# TODO: Write documentation for `SplatfestSimulator`
module SplatfestSimulator
  VERSION = "0.1.0"

  # TODO: Put your code here
end

require "./splatfest_simulator/league.cr"
require "./splatfest_simulator/match.cr"
require "./splatfest_simulator/matchmaker.cr"
require "./splatfest_simulator/splatfest_matchmaker.cr"
require "./splatfest_simulator/team.cr"

include SplatfestSimulator

# good_team = Team.new(4.times.map{Player.new(elo=2000)})
# bad_team = Team.new(4.times.map{Player.new(elo=1700)})

# win_counts = {:a => 0, :b => 0}

# 100_000.times do
#   random_team = Team.new
#   m = Match.new([good_team, bad_team])
#   win_counts[m.winner] += 1
# end

# p win_counts

# mm = Matchmaker.new
# all_matches = mm.make_all_matches!

# average_elo_delta = all_matches.map do |match|
#   Float64.new(match.elo_delta)
# end.sum / all_matches.size

# p average_elo_delta

knight_teams = 3732.times.map do
  Team.new(faction: :knight)
end.to_a

wizard_teams = 6268.times.map do
  Team.new(faction: :wizard)
end.to_a

10.times do |n|
  print "\r#{n}"
  smm = SplatfestMatchmaker.new(knight_teams: knight_teams.dup,
                                wizard_teams: wizard_teams.dup)

  smm.make_all_matches!.each(&.judge!)
end
puts

puts "highest clout scores"


p knight_teams.map(&.clout).sort.last(5)
p wizard_teams.map(&.clout).sort.last(5)

puts "lowest clout scores"
p knight_teams.map(&.clout).sort.first(5)
p wizard_teams.map(&.clout).sort.first(5)

p knight_teams.map(&.clout).sum
p wizard_teams.map(&.clout).sum
