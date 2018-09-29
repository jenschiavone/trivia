require './contestant.rb'

class Session
  attr_accessor :contestants, :number_of_questions

  def initialize(number_of_questions)
    @contestants = []
    @number_of_questions = number_of_questions
  end

  def contestants
    @contestants
  end

  def number_of_questions
    @number_of_questions
  end

  def get_contestant_by_id(id)
    self.contestants.find { |c| c.id == id }
  end

  def get_contestant_by_username(username)
    self.contestants.find { |c| c.username == username }
  end

  def check_all_averages
    contestants = self.contestants
    if !contestants.empty?
      puts "\n"
      puts "*** All Contestant Averages ***"
      contestants.each do |contestant|
        puts "#{contestant.username}: #{contestant.average}%"
      end
    end
  end
end
