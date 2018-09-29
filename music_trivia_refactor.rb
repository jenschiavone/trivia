require './contestant.rb'
require './exam.rb'
require './question.rb'
require './session.rb'

def goodbye
	abort("Goodbye")
end

def create_session
  session = Session.new
  add_contestant(session)
end

def add_contestant(session)
	puts "\n"
	puts "Let's play Music Trivia!"

  first_name = ""
  until first_name != ""
    puts "Please enter your first name:"
    first_name = gets.chomp.capitalize
  end

  last_name = ""
  until last_name != ""
    puts "Please enter your last name:"
    last_name = gets.chomp.capitalize
  end

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

	contestant = Contestant.new(first_name, last_name, username)

	session.contestants << contestant

	print_menu(true, contestant, session)
end

def print_menu(option, contestant, session)
	if option
		system "clear"
	end

	if !contestant.available_categories.empty?
		puts "Please choose a category, #{contestant.username}: "
		category_label = 1
		contestant.available_categories.each do |category|
			puts "#{category_label}. #{category}"
			category_label += 1
		end
		puts "E. Exit"

		#dynamically setting the valid choices so user can be prompted if he/she enters an invalid choice
		number_of_categories = contestant.available_categories.length
		valid_choices = (1.."#{number_of_categories}".to_i).to_a.map { |i| i.to_s }
		choices_hash = {}
		index = 0
		valid_choices.each do |key|
			choices_hash[key] = contestant.available_categories[index]
			index += 1
		end

		valid_choices.push("E", "e")
		valid_choices_string = valid_choices.join(",")
		choice = gets.chomp

		until valid_choices.any? { |c| c.include?("#{choice}")} && choice != ""
			puts "Please enter a valid selection (#{valid_choices_string})"
			choice = gets.chomp
		end

		case choice
		 	when "1"
		 		puts "\n"
		 		category = choices_hash['1']
		 		puts "You chose #{category}"
		 		choose_number_of_questions(category, contestant, session)
		 	when "2"
		 		puts "\n"
		 		category = choices_hash['2']
		 		puts "You chose #{category}"
		 		choose_number_of_questions(category, contestant, session)
		 	when "3"
		 		puts "\n"
		 		category = choices_hash['3']
		 		puts "You chose #{category}"
		 		choose_number_of_questions(category, contestant, session)
		 	when "4"
		 		puts "\n"
		 		category = choices_hash['4']
		 		puts "You chose #{category}"
		 		choose_number_of_questions(category, contestant, session)
		 	when "5"
		 		puts "\n"
		 		category = choices_hash['5']
		 		puts "You chose #{category}"
		 		choose_number_of_questions(category, contestant, session)
		 	when "E", "e"
		 		goodbye
		end
	else
		puts "Congratulations, you've completed all categories!"
		check_scores(contestant.id, session)
	end
end


def choose_number_of_questions(category, contestant, session)

	questions = ""
	until questions != ""
		puts "How many questions would you like?"
		puts "1. 5 questions"
		puts "2. 10 questions"
		puts "3. 15 questions"
		puts "E. Exit"
		questions = gets.chomp.downcase
	end

	case questions
	 	when "1"
	 		number_of_questions = 5
	 		puts "\n"
	 		puts "You chose #{number_of_questions} questions about #{category}"
	 		take_exam(category, number_of_questions, contestant, session)
	 	when "2"
	 		number_of_questions = 10
	 		puts "\n"
	 		puts "You chose #{number_of_questions} questions about #{category}"
	 		take_exam(category, number_of_questions, contestant, session)
	 	when "3"
	 		number_of_questions = 15
	 		puts "\n"
	 		puts "You chose #{number_of_questions} questions about #{category}"
	 		take_exam(category, number_of_questions, contestant, session)
	 	when "E", "e"
	 		goodbye
	 	else
	 		puts "Please enter a valid selection (1, 2, 3, E, e)"
	 		choose_number_of_questions(category, contestant, session)
	end
end


def take_exam(category, number_of_questions, contestant, session)
	puts "Good luck, #{contestant.username}!"

  exam = Exam.new(category, number_of_questions)
	exam.take_exam

	contestant.available_categories.delete("#{category}")

	calculate_score(exam, contestant, category, session)
  #set final scores
  #set average
end


def set_search_method(contestant, session)

	puts "How would you like to proceed?"
	puts "1. Find player by username"
	puts "2. Find player by last name"
	puts "E. Exit"

	valid_choices = %w(1 2 E e)
	valid_choices_string = valid_choices.join(",")

	choice = gets.chomp

	until valid_choices.any? { |c| c.include?("#{choice}")} && choice != ""
  	puts "Please enter a valid selection (#{valid_choices_string})"
  	choice = gets.chomp
	end

	case choice
	 	when "1"
	 		search = "by_username"
	 		get_contestant(search, contestant, session)
	 	when "2"
	 		search = "by_last_name"
	 		get_contestant(search, contestant, session)
	 	when "E", "e"
	 		goodbye
	end
end

def check_all_averages(contestant, session)
	session.check_all_averages
	submenu(contestant, session)
end

def get_contestant(search, contestant, session)
  contestants = session.contestants
		if !contestants.empty?
			if search == "by_last_name"
				puts "Please enter the player's last name"
				last_name = gets.chomp.capitalize
				matching_contestants = contestants.select {|c| c.last_name == last_name}
			elsif search == "by_username"
				puts "Please enter the player's username"
				username = gets.chomp.downcase
				matching_contestants = contestants.select {|c| c.username == username}
			end
			if !matching_contestants.empty?
				if matching_contestants.length == 1
					print_menu(true, contestants.first, session)
				else
					puts "The following players match your search:"
					contestant_ids = []
					matching_contestants.each do |contestant|
						contestant_ids << contestant.id.to_s
						puts "Player Id = #{contestant.id}: #{contestant.last_name}, #{contestant.first_name}, #{contestant.username}"
						end
					contestant_ids_string = contestant_ids.join(",")
					puts "Please enter the desired Player Id"
					choice = gets.chomp
					until contestant_ids.any? { |c| c.include?("#{choice}")}
  					puts "Please enter a valid selection (#{contestant_ids_string})"
  					choice = gets.chomp
					end
          contestant = session.get_contestant_by_id(choice.to_i)
					print_menu(true, contestant, session)

				end
			else
				puts "\n"
				puts "*** There are no players who match your search ***"
				submenu(contestant, session)
			end
		else
				puts "*** There are no players in the database ***"
				print_menu(false)
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
	puts "1. Play another category"
	puts "2. Create new player"
	puts "3. Switch to existing player"
	puts "4. Check your scores"
	puts "5. Check all player averages"
	puts "E. Exit"

	valid_choices = %w(1 2 3 4 5 E e)
	valid_choices_string = valid_choices.join(",")

	choice = gets.chomp

	until valid_choices.any? { |c| c.include?("#{choice}")} && choice != ""
  	puts "Please enter a valid selection (#{valid_choices_string})"
  	choice = gets.chomp
	end

	case choice
	 	when "1"
	 		print_menu(true, contestant, session)
	 	when "2"
	 		add_contestant(session)
	 	when "3"
	 		set_search_method(contestant, session)
	 	when "4"
	 		check_scores(contestant, session)
	 	when "5"
	 		check_all_averages(contestant, session)
	 	when "E", "e"
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

print_menu(false)


