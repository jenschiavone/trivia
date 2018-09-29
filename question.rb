class Question

  attr_accessor :question, :choices, :answer

  def initialize(question, choices, answer)
    @question = question
    @choices = choices
    @answer = answer
  end

  def question
    @question
  end

  def choices
    @choices
  end

  def answer
    @answer
  end
end
