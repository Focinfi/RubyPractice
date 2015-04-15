# Implement ruby Array inject func as my_inject
# 1. 破坏原数组
# 2. meth = meth || blk
module Enumerable
  def my_inject(acc=nil, meth=nil, &blk)
    meth,acc = [acc,nil] unless blk || meth
    meth = meth || blk
    raise "should provide method_name or block" unless meth && meth.respond_to?(:to_proc)

    dup.arr_inject(acc, &meth.to_proc)
  end
  def arr_inject(acc)
    acc ||= shift
    each {|v| acc = yield acc,v}
    acc
  end
end


require 'minitest/autorun'
class TestMyInject < MiniTest::Unit::TestCase
	def setup
		@num_arr = [1, 2, 3, 4]
		@sum_proc = Proc.new { |s, i| s + i * 10 }
		@multi_proc = Proc.new { |m, i| m * i * i }
	end

	def test_sum_elements_with_initial_num
		assert_equal @num_arr.inject(100, &@sum_proc), 
			@num_arr.my_inject(100, &@sum_proc)
	end

	def test_sum_elements_without_initial_num
		assert_equal @num_arr.inject(&@sum_proc), 
			@num_arr.my_inject(&@sum_proc)
	end

	def test_multi_elements_with_initial_num
		assert_equal @num_arr.inject(100, &@multi_proc), 
			@num_arr.my_inject(100, &@multi_proc)
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

	def test_pass_a_block_param
		assert_equal @num_arr.inject(1, :+, &:*), @num_arr.my_inject(1, :+, &:*)
	end

	def test_pass_a_block_param
		assert_equal @num_arr.inject(1, :+, &:*), @num_arr.my_inject(1, :+, &:*)
	end

	def test_rang
		rang = (1..10)
		assert_equal @num_arr.inject(:+), @num_arr.my_inject(:+)
	end
end

#