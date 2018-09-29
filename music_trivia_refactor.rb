require './contestant.rb'
require './exam.rb'
require './question.rb'
require './session.rb'

def goodbye
	abort("Goodbye")
end

def create_session
  puts "\n"
  puts "Let's play Music Trivia!"
  session = Session.new(number_of_questions)
  add_contestant(session)
end

def add_contestant(session)
	choice = ""
	until choice != ""
		puts "Please enter a user name:"
		choice = gets.chomp.downcase
	end

  contestants = session.contestants

	if !contestants.empty?
		usernames = []
		contestants.each do |contestant|
			usernames << contestant.username
		end
		while usernames.any? { |u| u.include?("#{choice}")}
			puts "That username is already taken. Please choose another."
			choice = gets.chomp.downcase
		end
		username = choice
	else
		username = choice
	end

	contestant = Contestant.new(username)

	session.contestants << contestant

	print_menu(true, contestant, session)
end

def print_menu(option, contestant, session)
	if option
		system "clear"
	end

	if !contestant.available_categories.empty?
		puts "Please choose a category, #{contestant.username}: "
		category_label = "A"
		contestant.available_categories.each do |category|
			puts "#{category_label}. #{category}"
			category_label.next!
		end
		puts "Q. Quit"

		# setting the remaining choices so user can be prompted if he/she enters an invalid choice
		number_of_categories = contestant.available_categories.length
    all_choices = %w(A B C D E)
		remaining_choices = (all_choices.first..all_choices[number_of_categories - 1]).to_a
		choices_hash = {}
		index = 0
		remaining_choices.each do |key|
			choices_hash[key] = contestant.available_categories[index]
			index += 1
		end

		remaining_choices.push("Q")
		remaining_choices_string = remaining_choices.join(",")
		choice = gets.chomp.upcase

		until remaining_choices.any? { |c| c.include?("#{choice}")} && choice != ""
			puts "Please enter a valid selection (#{remaining_choices_string})"
			choice = gets.chomp.upcase
		end

		case choice
		 	when "A"
		 		puts "\n"
		 		category = choices_hash['A']
		 		puts "You chose #{category}"
		 		take_exam(category, contestant, session)
		 	when "B"
		 		puts "\n"
		 		category = choices_hash['B']
		 		puts "You chose #{category}"
		 		take_exam(category, contestant, session)
		 	when "C"
		 		puts "\n"
		 		category = choices_hash['C']
		 		puts "You chose #{category}"
		 		take_exam(category, contestant, session)
		 	when "D"
		 		puts "\n"
		 		category = choices_hash['D']
		 		puts "You chose #{category}"
		 		take_exam(category, contestant, session)
		 	when "E"
		 		puts "\n"
		 		category = choices_hash['E']
		 		puts "You chose #{category}"
		 		take_exam(category, contestant, session)
		 	when "Q"
		 		goodbye
		end
	else
		puts "Congratulations, you've completed all categories!"
		check_scores(contestant.id, session)
	end
end


def number_of_questions

	questions = ""
	until questions != ""
		puts "How many questions would you like for this session?"
		puts "A. 5 questions"
		puts "B. 10 questions"
		puts "C. 15 questions"
		puts "Q. Quit"
		questions = gets.chomp.upcase
	end

  number = ""
	case questions
	 	when "A" then number = 5
	 	when "B" then number = 10
	 	when "C" then number = 15
	 	when "Q" then goodbye
	 	else
	 		puts "Please enter a valid selection (A, B, C, Q)"
	 		number_of_questions
	end
  number
end


def take_exam(category, contestant, session)
	puts "Good luck, #{contestant.username}!"

  exam = Exam.new(category, session.number_of_questions)
	exam.take_exam

	contestant.available_categories.delete("#{category}")

	calculate_score(exam, contestant, category, session)
  #set final scores
  #set average
end

def check_all_averages(contestant, session)
	session.check_all_averages
	submenu(contestant, session)
end

def switch_contestant(contestant, session)
  puts "Please enter the contestant's username"
  username = gets.chomp.downcase
  matching_contestant = session.get_contestant_by_username(username)
  if matching_contestant != nil
    print_menu(true, matching_contestant, session)
  else
    puts "\n"
    puts "*** There are no contestants who match your search ***"
    submenu(contestant, session)
  end
end

def calculate_score(exam, contestant, category, session)
  score = exam.score
	contestant.scores.each do |item|
		if item.has_value?("#{category}")
			item['score'] = score
			contestant.final_scores.push(score.to_i)
		end
	end
	average = contestant.final_scores.inject { |sum, el| sum + el}.to_f / contestant.final_scores.length.to_f
	average = average.round
	contestant.average = average

	submenu(contestant, session)
end

def submenu(contestant, session)

	puts "\n"
	puts "What would you like to do next, #{contestant.username}?"
	puts "A. Play another category"
	puts "B. Create new contestant"
	puts "C. Switch to another contestant"
	puts "D. Check your scores"
	puts "E. Check all contestant averages"
	puts "Q. Quit"

	valid_choices = %w(A B C D E Q)
	valid_choices_string = valid_choices.join(",")

	choice = gets.chomp.upcase

	until valid_choices.any? { |c| c.include?("#{choice}")} && choice != ""
  	puts "Please enter a valid selection (#{valid_choices_string})"
  	choice = gets.chomp.upcase
	end

	case choice
	 	when "A"
	 		print_menu(true, contestant, session)
	 	when "B"
	 		add_contestant(session)
	 	when "C"
	 		switch_contestant(contestant, session)
	 	when "D"
	 		check_scores(contestant, session)
	 	when "E"
	 		check_all_averages(contestant, session)
	 	when "Q"
	 		goodbye
	end
end

def check_scores(contestant, session)
	contestant.check_scores
	submenu(contestant, session)
end

# *******START*******

play = ""
contestant = ""

until play == "y" || play == "n"
	system "clear"
	$stdout.sync = true
	"Want to play a game? (y/n): ".each_char {|c| putc c ; sleep 0.05; $stdout.flush }
	play = gets.chomp.downcase
end

if play == "y"
	create_session
elsif play == "n"
	goodbye
end

