require 'minitest/autorun'
require './game.rb'

class GameTest < MiniTest::Unit::TestCase
	def setup
		@gamer = TWGame.new
	end

	# support methods
	def set_input arr
		@gamer.input_arr = arr
	end

	def match_taboo_in_twgame(num)
		@gamer.match_taboo(num, @gamer.input_arr)
	end

	def match_divisible_in_twgame(num)
		@gamer.match_divisible(num, @gamer.input_arr)
	end

	def test_make_arr_from_str
		assert ['11', '3', '4', 'as', 'd'], @gamer.make_arr_from_str(' 11 2 3 as d ')
	end

	def test_return_true_when_input_with_different_nums
		assert_equal true, @gamer.validate_input(%w{ 1 2 3 })
	end

	def test_return_false_when_input_nums_string_length_is_not_3
		assert_equal false, @gamer.validate_input(%w{ 12 2 1 })
		assert_equal false, @gamer.validate_input(%w{ 1 2 3 4 })
	end

	def test_return_false_when_input_nums_not_unique
		assert_equal false, @gamer.validate_input(%w{ 1 2 2 })
	end

	def test_return_false_when_input_is_not_all_num
		assert_equal false, @gamer.validate_input(%w{ 1 s 2 })
	end

	def test_return_codeword_or_nil_when_a_num_in_1_100_match_taboo
		set_input(%w{ 4 7 3 })
		assert_equal nil, match_taboo_in_twgame('50')
		assert_equal TWTool::PASS_CODE[1], match_taboo_in_twgame('76')
	end

	def test_return_codeword_combination_when_a_num_1_100_is_divisible_by_one_or_more_taboo
		set_input(%w{ 4 5 3 })
		assert_equal nil, match_divisible_in_twgame('7')

		assert_equal TWTool::PASS_CODE[0]+
									TWTool::PASS_CODE[2],
								 match_divisible_in_twgame('12')

		assert_equal TWTool::PASS_CODE[0]+
									TWTool::PASS_CODE[1]+
									TWTool::PASS_CODE[2],
								 match_divisible_in_twgame('60')
	end

	def test_make_result_array_first_6_elements
		set_input(%w{ 3 2 4 })
		assert_equal [
									"1",
									TWTool::PASS_CODE[1],
									TWTool::PASS_CODE[0],
									TWTool::PASS_CODE[2],
									"5",
									TWTool::PASS_CODE[0] + TWTool::PASS_CODE[1]
								 ],
								 @gamer.make_result_arr(@gamer.input_arr).first(6)
	end

end
