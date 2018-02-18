require 'sinatra'
require 'sass'
require 'set'

words = ["obstruction", "manipulation", "indentation", "vibrant",
"redemtion", "hapiness", "smallpox", "strawberry"]
messages_failure = ["not like this", "try again", "you are doing it wrong"]
messages_success = ["keep it up", "you  are getting there", "good job"]
new_word = false
my_word = words[rand(8)]
guessed_letters = Set.new
counter = 0
get '/' do
	guess = params['guess']
	new_word = params['new_word']
	if not guess.nil? and counter < 9
		for i_idx in 0..word.size-1
			if my_word[i_idx] == guess and not guessed_letters.include?(guess)
				@@message = messages_success[rand(3)]
			else
				@@message = messages_failure[rand(3)]
				counter += 1
			end
		end
	end

	if counter = 9
		@@message = "You are hanged!"
	end

	@@current_stage_image = counter.to_s + ".jpg"

	haml "index.html".to_sym, :layout => "layout.html".to_sym
end