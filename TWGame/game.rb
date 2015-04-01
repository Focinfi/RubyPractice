module TWGameIO
  GREETING = <<-END_OF_GREETING
  -----------------TWGame---------------------
  Plese type three unique digits, like '3 5 7':
  END_OF_GREETING

  WARNNING = <<-END_OF_WARNING

  ---------------Invalid INPUT!----------------
  You can type ^c to quit.
  END_OF_WARNING
	
	#input
	def input_string
		gets.chomp
	end

	#output
	def puts_greeting
		puts GREETING
	end

	def puts_warnning
		puts WARNNING
	end

	def puts_result arr
		puts "---------RESULT OF #{@input_arr.join " "}-----------"
		arr.each { |element| puts "#{element}\n\n" }
	end	
end

module TWTool
	PASS_CODE = ['Fizz', 'Buzz', 'Whizz']

	def make_result_arr input_arr
		result_arr = []
		result_item = nil
		('1'..'100').each do |num|
			result_item = match_taboo(num, input_arr)
			result_item = match_divisible(num, input_arr) unless result_item
			result_item = num unless result_item
			result_arr << result_item
		end
		result_arr
	end

	def match_taboo(num, match_arr)
		done = false
		result_item = nil
		num.chars.each do |char|  
			match_arr.each_with_index do |taboo, index|
				if char.eql? taboo
					result_item = PASS_CODE[index]
					done = true
					break
				end
			end
			break if done
		end
		result_item
	end

	def match_divisible(num, match_arr)
		result_item = ""
		num = num.to_i
		match_arr.each_with_index do |baboo, index|
			result_item << PASS_CODE[index] if num % baboo.to_i == 0
		end
		result_item.empty? ? nil : result_item
	end
		
	def make_arr_from_str input
		input.strip.squeeze.split /[\s]/
	end

	def validate_input input_arr
		return false if input_arr.join.length != 3
		return false if input_arr.uniq.length != 3
		return false if input_arr.join =~ /[^\d\s]/		
		true
	end
end

class TWGame
	include TWGameIO, TWTool
	attr_accessor :input_arr, :result_arr

	#game run entry
	def run
		puts_greeting
		@input_arr = make_arr_from_str(input_string)
		if(validate_input @input_arr)
			@result_arr = make_result_arr(@input_arr)
			puts_result(@result_arr)
		else
			puts_warnning
			run
		end
	end
end

TWGame.new.run