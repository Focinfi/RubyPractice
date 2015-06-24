require 'factory_pattern'
require 'pattern_helper'

RSpec.describe 'Factory Pattern' do
  describe Pizza do
    let(:pizza) { Pizza.new }

    it "has a name" do
      expect(pizza.name).to eq 'Pizza'
    end
  end

  describe SweetPizza do
    let(:sweet_pizza) { SweetPizza.new } 

    it "is named of sweet_pizza" do
      expect(sweet_pizza.name).to eq 'Sweet Pizza'
    end
  end

  describe TomatoPizza do
    let(:tomato_pizza) { TomatoPizza.new }

    it "is named of tomato_pizza" do
      expect(tomato_pizza.name).to eq 'Tomato Pizza'
    end
  end

  describe PizzaFactory do
    let(:pizza_factory) { PizzaFactory.new }

    it "has pizza" do
      expect(pizza_factory.pizzas_category['pizza']).to eq Pizza
    end
  end

  describe FrankPizzaFactory do
    let(:pizza_factory) { FrankPizzaFactory.new }

    it "makes a pizza" do
      pizza = pizza_factory.make_pizza_by 'pizza'
      expect(pizza.name).to eq 'Pizza'
    end
  end

  describe PizzaStore do
    let(:pizza_store) { PizzaStore.new } 

    it "has name" do
      expect(pizza_store.name).to eq 'Pizza Store'
    end

    it "has a create_pizza_by and order_pizza_by method" do
      expect(pizza_store.methods.contain? [:create_pizza_by, :order_pizza_by]).to eq true
    end
  end

  describe FrankPizzaStore do
    let(:frank_pizza_store) { FrankPizzaStore.new } 

    context 'FrankPizzaStore Information' do
      it "has name" do
        expect(frank_pizza_store.name).to eq "Frank Pizza Store"
      end

      it "has FrankPizzaFactory" do
        expect(frank_pizza_store.pizza_factory.class).to eq FrankPizzaFactory
      end
    end

    context 'FrankPizzaFactory Order Pizza' do
      it "orders a default pizza" do
        order_msg = frank_pizza_store.order_pizza_by 'Cola'
        expect(order_msg).to eq 'Making Pizza ...'
      end

      it "orders a Sweet Pizza" do
        order_msg = frank_pizza_store.order_pizza_by 'sweet_pizza'
        expect(order_msg).to eq 'Making Sweet Pizza ...'
      end

      it "orders a Tomato Pizza" do
        order_msg = frank_pizza_store.order_pizza_by 'tomato_pizza'
        expect(order_msg).to eq 'Making Tomato Pizza ...'
      end
    end
  end

end
