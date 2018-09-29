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
end
