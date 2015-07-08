# Implement ruby Array inject func as my_inject
module Enumerable
  def my_inject *arg
    initial = method = nil

    tmp = Array.new(self)

    if arg.length > 2
      raise ArgumentError, "wrong number of arguments #{arg.length} for 0..2"
    elsif arg.length == 2
      initial, method = arg[0], arg[1]
    elsif arg.first.is_a? Symbol
      method = arg.first
    elsif arg.first
      initial = arg.first
    end

    accumulation = initial ? initial : tmp.shift

    if method
      tmp.each do |element|
        accumulation = accumulation.send(method, element)
      end
    else
      tmp.each do |element|
        accumulation = yield accumulation, element
      end
    end

    accumulation
  end
end
# p [1, 2, 3].my_inject(:*, &:*){}
require 'minitest/autorun'
class TestMyInject < Minitest::Test
	def setup
		@num_arr = [1, 2, 3, 4]
		@sum_proc = Proc.new { |s, i| s + i * 10 }
		@multi_proc = Proc.new { |m, i| m * i * i }
	end

	def test_sum_elements_with_initial_num
		assert_equal @num_arr.inject(100.2, &@sum_proc),
			@num_arr.my_inject(100.2, &@sum_proc)
	end

	def test_sum_elements_without_initial_num
		assert_equal @num_arr.inject(&@sum_proc),
			@num_arr.my_inject(&@sum_proc)
	end

	def test_multi_elements_with_initial_num
		assert_equal @num_arr.inject(100.2, &@multi_proc),
			@num_arr.my_inject(100.2, &@multi_proc)
	end

	def test_multi_elements_with_initial_num
		assert_equal @num_arr.inject(&@multi_proc),
			@num_arr.my_inject(&@multi_proc)
	end

	def test_sum_elements_with_sum_symbol
		assert_equal @num_arr.inject(:+), @num_arr.my_inject(:+)
	end

	def test_multi_elements_with_multi_symbol
		assert_equal @num_arr.inject(:*), @num_arr.my_inject(:*)
	end

	def test_two_params_with_initial_sum_symbol
		assert_equal @num_arr.inject(10.2, :+), @num_arr.my_inject(10.2, :+)
	end

	def test_with_block_parameter
		assert_equal @num_arr.inject(&:+), @num_arr.my_inject(&:+)
	end

	def test_pass_a_block_param
		assert_equal @num_arr.inject(1, :+, &:*), @num_arr.my_inject(1, :+, &:*)
	end

	def test_rang
		rang = (1..10)
		assert_equal @num_arr.inject(:+), @num_arr.my_inject(:+)
	end

end
