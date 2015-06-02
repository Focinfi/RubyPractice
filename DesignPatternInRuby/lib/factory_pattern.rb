class Pizza
  attr_reader :name

  def initialize
    @name = 'Pizza'
  end
end

class SweetPizza < Pizza
  def initialize
    @name = 'Sweet Pizza'
  end
end

class TomatoPizza < Pizza
  def initialize
    @name = 'Tomato Pizza'
  end
end

class PizzaFactory
  attr_reader :pizzas_category

  def initialize
    @pizzas_category = Hash.new { |h, k| h[k] = Pizza }
  end
end

class FrankPizzaFactory < PizzaFactory
  def initialize
    super
    @pizzas_category['sweet_pizza'] = SweetPizza
    @pizzas_category['tomato_pizza'] = TomatoPizza
  end

  def make_pizza_by name
    @pizzas_category[name].new
  end
end

class PizzaStore
  attr_reader  :name, :pizza_factory

  def initialize
    @name = 'Pizza Store'
    @pizza = Pizza.new
    @pizza_factory = PizzaFactory.new
  end

  def create_pizza_by name
    @pizza
  end

  def order_pizza_by name
    make create_pizza_by name
  end

  def make pizza
    "Making #{pizza.name} ..."
  end
end

class FrankPizzaStore < PizzaStore
  def initialize
    @name = 'Frank Pizza Store'
    @pizza_factory = FrankPizzaFactory.new
  end

  def create_pizza_by name
    @pizza_factory.make_pizza_by name
  end
end
