module SplatfestSimulator
  class Player
    getter elo : Int32

    def initialize(@elo=rand(2500))
    end
  end
end
