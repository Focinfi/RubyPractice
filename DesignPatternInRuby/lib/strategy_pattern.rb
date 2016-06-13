class FlyBehaviour
  def fly f = "Can not fly"
    f
  end
end

class FlyWithWings < FlyBehaviour
  def fly
    super "Flying with wings"
  end
end

class QuackBehaviour
  def quack q = nil
    q
  end
end

class Squeak < QuackBehaviour
  def quack
    super "ZhiZhi"
  end
end


class Duck
  attr_reader :name
  attr_accessor :fly_behaviour, :quack_behaviour

  def initialize name
    @name = name
    @fly_behaviour = FlyBehaviour.new
    @quack_behaviour = QuackBehaviour.new
  end

  def perform_fly
    @fly_behaviour.fly
  end

  def perform_quack
    @quack_behaviour.quack
  end

  def swim
    "I am #{name} and I am swimming."
  end

  def display
    "I am #{name}, nice to meet you."
  end
end


class StupidDuck < Duck
  def initialize name
    super name
  end
end

class ReadHeadDuck < Duck
  def initialize name
    super name
    @fly_behaviour = FlyWithWings.new
    @quack_behaviour = Squeak.new
  end
end
