##
# Counter is thread safe, we use a Mutex to guarantee the atomicity of #increment!
#
class Counter
  attr_reader :total

  def initialize
    puts 'initialized'
    @total = 0
    @mutex = Mutex.new
  end

  def increment!
    @mutex.synchronize { @total += 1 }
  end
end

##
# Application isn't thread safe, because the initialization of Counter
# happens with a non-atomic operation (`||=`).
#
class Application
  def increment!
    counter.increment!
  end

  def counter
    @counter ||= Counter.new
  end

  def total
    counter.total
  end
end

app = Application.new

10.times.map do |i|
  Thread.new do
    app.increment!
    puts app.counter.object_id, ''
  end
end.each(&:join)

puts app.total