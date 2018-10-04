require './trivia_data.rb'
require './question.rb'

class Exam
  include TriviaData

  attr_accessor :questions

  VALID_ANSWERS = %w(A B C D)

  def initialize(category, number_of_questions)
    exam_questions = []
    case category
      when "The Beatles"
        questions = TriviaData::beatles
        questions.each do |question|
          exam_questions << Question.new(question['question'], question['choices'], question['answer'])
        end
      when "The 80s"
        questions = TriviaData::eighties
        questions.each do |question|
          exam_questions << Question.new(question['question'], question['choices'], question['answer'])
        end
      when "Indie Rock"
        questions = TriviaData::indie
        questions.each do |question|
          exam_questions << Question.new(question['question'], question['choices'], question['answer'])
        end
      when "Rap/Hip Hop"
        questions = TriviaData::hiphop
        questions.each do |question|
          exam_questions << Question.new(question['question'], question['choices'], question['answer'])
        end
      when "Jazz"
        questions = TriviaData::jazz
        questions.each do |question|
          exam_questions << Question.new(question['question'], question['choices'], question['answer'])
        end
    end
    @questions = exam_questions.sample(number_of_questions)
    @correct_answers = []
    @incorrect_answers = []
    @number_of_questions = number_of_questions
  end

  def questions
    @questions
  end

  def correct_answers
    @correct_answers
  end

  def incorrect_answers
    @incorrect_answers
  end

  def number_of_questions
    @number_of_questions
  end

  def take_exam
    score = 0
    question_number = 1
    questions.each do |question|
      puts "\n"
      puts "Question number #{question_number}: "
      puts question.question
      question.choices.each do |choice|
        puts choice
      end
      answer = gets.chomp.upcase
      until Exam::VALID_ANSWERS.any? { |a| a.include?("#{answer}")} && answer != ""
        puts "Please choose a valid answer: (A, B, C, or D)"
        answer = gets.chomp.upcase
      end
      if answer == question.answer
        puts "\n"
        puts "Correct!"
        @correct_answers.push(question)
        score += 1
      else
        puts "\n"
        puts "I'm sorry, that's incorrect."
        @incorrect_answers.push(question)
      end
      puts "You are #{score} for #{question_number}."
      question_number += 1
    end
  end

  def score
    score = self.correct_answers.length.to_f / self.number_of_questions.to_f
    score = (score * 100).round
    puts "That's #{score}%"
    score
  end
end
