require './contestant.rb'

class Session
  attr_accessor :contestants

  def initialize
    @contestants = []
  end

  def contestants
    @contestants
  end

  def get_contestant_by_id(id)
    self.contestants.find { |c| c.id == id }
  end

  def check_all_averages
    contestants = self.contestants
    if !contestants.empty?
      puts "\n"
      puts "*** All Player Averages ***"
      contestants.each do |contestant|
        puts "#{contestant.username}: #{contestant.average}%"
      end
    end
  end
end
