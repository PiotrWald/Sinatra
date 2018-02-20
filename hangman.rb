require 'sinatra'
require "sinatra/reloader" if development?
require 'sass'
require 'set'
get('/styles.css'){scss :styles}

#Caesar class used to encode a string

@@ciphered = ""
class Caesar
	def encode_string(my_string, shift_value)

			shift_value %= 26

		for i in 0..my_string.size-1 do
			if my_string[i].ord > 122 or my_string[i].ord < 97
				next
			end
				check_value = my_string[i].ord + shift_value
			if check_value > 122
					check_value -= 26
			elsif check_value < 97
					check_value += 26
			end
				my_string[i] = check_value.chr
		end
			return my_string
	end

end
x = Caesar.new


#Initializers for Hangman

words = ["obstruction", "manipulation", "indentation", "vibrant",
"redemtion", "hapiness", "smallpox", "strawberry"]
messages_failure = ["not like this", "try again", "you are doing it wrong"]
messages_success = ["keep it up", "you  are getting there", "good job"]
my_word = words[rand(8)]
guessed_letters = Set.new
@@counter = 0
@@message = "guess the word!"



get '/' do 
	haml "index.html".to_sym, :layout => "layout.html".to_sym
end

## Caesar ##

get '/caesar' do
	to_cipher = params['to_cipher']
	shift_value = params['shift_value'].to_i
	if not to_cipher.nil?
		@@ciphered = x.encode_string(to_cipher,shift_value)
	end

	haml "caesar.html".to_sym, :layout => "layout.html".to_sym
end

## Hangman ##

get '/hangman' do

	if params['reset'] == "reset"
		@@counter = 0
		guessed_letters = Set.new
		my_word = words[rand(8)]
		@message = "guess the word!"
	end

#Check if the letter has allready been used
	success = false
	@@my_word_display = ""
	guess = params['guess']
	new_word = params['new_word']
	if not guess.nil? and @@counter < 9
		for i_idx in 0..my_word.size-1
			if my_word[i_idx] == guess and not guessed_letters.include?(guess)
				success = true
			end
		end

		if success
			@@message = messages_success[rand(3)]
			guessed_letters.add(guess)
		else
			@@message = messages_failure[rand(3)]
			@@counter += 1
		end
	end


#Creation of a word with missing spaces for player to see

	for i_idx in 0..my_word.size-1
		if guessed_letters.include?(my_word[i_idx])
			@@my_word_display += my_word[i_idx]
		else
			@@my_word_display += "_"
		end
	end

	if @@counter == 9
		@@message = "You are hanged!"
		@@my_word_display = my_word
	end

	@@current_stage_image = @@counter.to_s + ".jpg"

	haml "hangman.html".to_sym, :layout => "layout.html".to_sym
end

