require 'decorate_pattern'

RSpec.describe 'Decorate Pattern' do
  describe Beverage do
    before :each do
      @beverage = Beverage.new
    end

    context "Basic information" do
      it "has empty description" do
        expect(@beverage.order_description).to be_nil
      end

      it "cost 0 when beverage is empty" do
        expect(@beverage.cost).to eq 0
      end
    end
  end

  describe "Basic Coffees" do
    before :each do
      @dark_roast = DarkRoast.new
    end

    context DarkRoast do
      it "has name" do
        expect(@dark_roast.name).to eq "DarkRoast Coffee"
      end

      it "has order_description" do
        expect(@dark_roast.order_description).to eq "DarkRoast Coffee"
      end

      it "cost 30 without any condiment" do
        expect(@dark_roast.cost).to eq 30
      end
    end
  end

  describe "Condiments" do
    context Milk do
      before :each do
        @milk = Milk.new
        @dark_roast = DarkRoast.new
        @beverage = @milk.add_to @dark_roast
      end

      it "has name" do
        expect(@milk.name).to eq 'Milk'
      end

      it "add to a beverage return as a beverage" do
        expect(@beverage.order_description).to eq "DarkRoast Coffee with Milk."
      end

      it "count total prices for a beverage" do
        expect(@beverage.cost).to eq 33.5
      end
    end

    context "Many Condiments" do
      before :context do
        @milk = Milk.new
        @sugar = Sugar.new
        @espresso = Espresso.new
        @beverage = @milk.add_to(@sugar.add_to @espresso)
      end

      context 'Many Condiments' do
        it "has description for the beverage" do
          expect(@beverage.order_description).to eq "Espresso Coffee with Sugar Milk."
        end

        it "should cost 35" do
          expect(@beverage.cost).to eq 25.0
        end
      end
    end

  end

end
