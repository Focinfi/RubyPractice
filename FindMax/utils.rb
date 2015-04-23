def Integer.rand_loop
  Enumerator.new do |yielder|
    loop { yielder.yield (rand * 10).to_i }
  end.lazy
end