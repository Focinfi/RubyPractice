class Beverage
  attr_reader :name

  def initialize
    @price = 0
    @beverage = nil
  end

  def order_description
    return name unless @beverage
    "#{@beverage.description} #{@name}."
  end

  def cost
    return @price unless @beverage
    @beverage.cost + @price
  end
end

class Coffee < Beverage
  def initialize
    @name = 'Coffee'
  end

  def description
    "#{@name} with"
  end

  def coffee_for name
    "#{name} Coffee"
  end
end

class Espresso < Coffee
  def initialize
    @name = coffee_for 'Espresso'
    @price = 20
  end
end

class DarkRoast < Coffee
  def initialize
    @name = coffee_for 'DarkRoast'
    @price = 30
  end
end

class Condiment < Beverage
  def initialize
    @name = coffee_for 'Condiment'
  end

  def description
    "#{@beverage.description} #{name}"
  end

  def add_to b
    @beverage = b
    self
  end
end

class Milk < Condiment
  def initialize
    @name = 'Milk'
    @price = 3.5
  end
end

class Sugar < Condiment
  def initialize
    @name = 'Sugar'
    @price = 1.5
  end
end
