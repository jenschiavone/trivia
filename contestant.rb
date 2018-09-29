class Contestant

  attr_accessor :first_name, :last_name, :username, :scores, :final_scores, :average, :available_categories

  @@id = 0

  def initialize(first_name, last_name, username)
    @@id += 1
    @first_name = first_name
    @last_name = last_name
    @username = username
    @id = @@id
    @scores = [
      {"category" => "The Beatles", "score" => "Not Yet Played"},
      {"category" => "The 80s", "score" => "Not Yet Played"},
      {"category" => "Indie Rock", "score" => "Not Yet Played"},
      {"category" => "Rap/Hip Hop", "score" => "Not Yet Played"},
      {"category" => "Jazz", "score" => "Not Yet Played"}
    ]
    @final_scores = []
    @average = ""
    @available_categories = ["The Beatles", "The 80s", "Indie Rock", "Rap/Hip Hop", "Jazz"]
  end

  def first_name
    @first_name
  end

  def last_name
    @last_name
  end

  def username
    @username
  end

  def id
    @id
  end

  def scores
    @scores
  end

  def final_scores
    @final_scores
  end

  def average
    @average
  end

  def available_categories
    @available_categories
  end

  def check_scores
    puts "\n"
    puts "Player is #{self.username}"

    self.scores.each do |item|
      score = item['score'] == "Not Yet Played" ? item['score'] : "#{item['score']}%"
      puts "Score for #{item['category']} is: #{score}"
    end

    puts "The average score for #{self.username} is #{self.average}%"
  end

end
