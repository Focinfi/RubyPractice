require 'minitest/autorun'

class FindMax
  attr_reader :digits, :max_indexs
  def initialize digit_str, len
    raise "Len must less than origin string's size" if len > digit_str.length
    @digits = digit_str.to_s.chars.map(&:to_i)
    @len = len    
    @max_indexs = max_indexs_with
  end
  
  def search
    return [@digits[@max_indexs[0], @len].join] if @max_indexs.length == 1
    max_indexs_temp = @max_indexs
    end_index = 0

    (@len - 1).times do |index| 
      if max_indexs_temp.length == 1
        end_index = index
        break
      end
      index += 1;
      max_indexs_temp = max_indexs_temp.map{ |d| d += 1 }
      max_indexs_temp = max_indexs_with range: max_indexs_temp
    end
    
    max_indexs_temp.map do |index|
      @digits[(index - end_index), @len].join
    end
  end  
  
  def max_indexs_with opts = {}
    range = opts[:range]
    range ||= (0..(@digits.length - @len)).to_a
    max_indexs = []    
    max = 0
    range.each do |index|
      if @digits[index] > max 
        max = @digits[index]
        max_indexs = [index]
      elsif @digits[index] == max
        max_indexs << index
      end
    end
    
    max_indexs
  end

end

class TestFindMax < MiniTest::Test
  def setup
    @digit_str = "12977311151994465246" 
    @len = 3
    @find_max = FindMax.new(@digit_str, @len)
  end
  
  def test_initialize
    assert_equal @digit_str.length, @find_max.digits.length
    assert_equal 1, @find_max.digits[0]
  end
  
  def test_max_indexs_with
    assert_equal [2, 11, 12], @find_max.max_indexs_with

  end
  
  def test_one_9_string
    find_max = FindMax.new("129773", 2)
    assert_equal ["97"], find_max.search
  end
  
  def test_find_max 
    assert_equal ["994"], @find_max.search
  end
end
