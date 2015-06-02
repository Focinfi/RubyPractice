require 'factory_pattern'

RSpec.describe 'Factory Pattern' do
  describe Pizza do
    before :each do
      @pizza = Pizza.new
    end

    it "has a name" do
      expect(@pizza.name).to eq 'Pizza'
    end
  end

  describe SweetPizza do
    before :each do
      @sweet_pizza = SweetPizza.new
    end

    it "is named of sweet_pizza" do
      expect(@sweet_pizza.name).to eq 'Sweet Pizza'
    end
  end

  describe TomatoPizza do
    before :each do
      @tomato_pizza = TomatoPizza.new
    end

    it "is named of tomato_pizza" do
      expect(@tomato_pizza.name).to eq 'Tomato Pizza'
    end
  end

  describe PizzaFactory do
    before :each do
      @pizza_factory = PizzaFactory.new
    end

    it "has pizza" do
      expect(@pizza_factory.pizzas_category['pizza']).to eq Pizza
    end
  end

  describe FrankPizzaFactory do
    before :each do
      @pizza_factory = FrankPizzaFactory.new
    end

    it "makes a pizza" do
      pizza = @pizza_factory.make_pizza_by 'pizza'
      expect(pizza.name).to eq 'Pizza'
    end
  end

  describe PizzaStore do
    before :each do
      @pizza_store = PizzaStore.new
    end

    it "has name" do
      expect(@pizza_store.name).to eq 'Pizza Store'
    end

    it "has a create_pizza_by and order_pizza_by method" do
      expect(@pizza_store.methods.contain? [:create_pizza_by, :order_pizza_by]).to eq true
    end
  end

  describe FrankPizzaStore do
    before :each do
      @frank_pizza_store = FrankPizzaStore.new
    end

    context 'FrankPizzaStore Information' do
      it "has name" do
        expect(@frank_pizza_store.name).to eq "Frank Pizza Store"
      end

      it "has FrankPizzaFactory" do
        expect(@frank_pizza_store.pizza_factory.class).to eq FrankPizzaFactory
      end
    end

    context 'FrankPizzaFactory Order Pizza' do
      it "orders a default pizza" do
        order_msg = @frank_pizza_store.order_pizza_by 'Cola'
        expect(order_msg).to eq 'Making Pizza ...'
      end

      it "orders a Sweet Pizza" do
        order_msg = @frank_pizza_store.order_pizza_by 'sweet_pizza'
        expect(order_msg).to eq 'Making Sweet Pizza ...'
      end

      it "orders a Tomato Pizza" do
        order_msg = @frank_pizza_store.order_pizza_by 'tomato_pizza'
        expect(order_msg).to eq 'Making Tomato Pizza ...'
      end
    end
  end

end
