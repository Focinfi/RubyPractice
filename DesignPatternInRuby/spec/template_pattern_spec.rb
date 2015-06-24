require 'template_pattern'
require 'pattern_helper'

RSpec.describe 'Template Pattern' do
  def test_coffeine_steps beverage
      expect(beverage.methods).to be_contain [:boil_water, :brew, :pour_in_cup, :add_condiment]
  end

  describe Coffee do
    it "has four steps to make Coffee" do
      test_coffeine_steps Coffee.new
    end
  end

  describe Tea do
    it "has four steps to make tea" do
      test_coffeine_steps Tea.new
    end
  end

  describe CoffeineBeverage do
    before :each do
      @coffee = Coffee.new
      @coffeine_beverage = CoffeineBeverage.new @coffee
    end

    it "has four steps to make Coffeine" do
      test_coffeine_steps @coffeine_beverage
    end
  end
end
