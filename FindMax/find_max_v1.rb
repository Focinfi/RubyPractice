require "minitest/autorun"

def find_max(origin, len)
  raise "Len must less than origin string's size" if len > origin.size
  queue = origin.to_s.chars
  max = queue.first(len).join.to_i
  queue.shift(1)
  last_index = queue.length - len
  
  queue.each_with_index do |i, index|
    break if index > last_index
    wait = queue[index...(index + len)].join.to_i
    max =  wait > max ? wait : max
  end
  
  max
end

class TestFindMax < MiniTest::Test
  def setup
    @origin_show = "123623467034"
  end

#   def test_raise_exception
#     find_max(@origin, 11)
#   end
  def test_find_max
    assert_equal 703, find_max(@origin_show, 3);
  end
end







