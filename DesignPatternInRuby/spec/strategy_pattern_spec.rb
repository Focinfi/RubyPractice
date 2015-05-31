require 'strategy_pattern'

RSpec.describe "StrategyPattern" do

  describe Duck do
    before :each do
      @duck = Duck.new("duck")
    end

    context "Duck initialize" do
      it "create new Duck object" do
        expect(@duck).to be_truthy
      end

      it "has a fly behaviour" do
        expect(@duck.fly_behaviour.class).to eq FlyBehaviour
      end

      it "has a quack behaviour" do
        expect(@duck.quack_behaviour.class).to eq QuackBehaviour
      end
    end

    context "Duck fly behaviour" do
      it "can not fly by default" do
        expect(@duck.perform_fly).to eq "Can not fly"
      end

      it "can fly when set fly_behaviour a value" do
        @duck.fly_behaviour = FlyWithWings.new
        expect(@duck.perform_fly).to eq "Flying with wings"
      end
    end

    context "Duck quack behaviour" do
      it "quack nothing by default" do
        expect(@duck.perform_quack).to be_nil
      end

      it "quack somethings when set quack_behaviour a value" do
        @duck.quack_behaviour = Squeak.new
        expect(@duck.perform_quack).to eq "ZhiZhi"
      end
    end
  end

  describe StupidDuck do
    before :each do
      @stupid_duck = StupidDuck.new("stupid_duck")
    end

    context "Fly and quack behaviour" do
      it "can not fly" do
        expect(@stupid_duck.perform_fly).to eq "Can not fly"
      end

      it "quack nothing" do
        expect(@stupid_duck.perform_quack).to be_nil
      end
    end
  end


  describe ReadHeadDuck do
    before :each do
      @red_head_duck = ReadHeadDuck.new("red_head")
    end

    context "Duck's subclass initialize" do
      it "has a name" do
        expect(@red_head_duck.name).to eq "red_head"
      end
    end

    context "Fly and quack behaviour" do
      it "can fly with wings" do
        expect(@red_head_duck.perform_fly).to eq "Flying with wings"
      end

      it "quack ZhiZhi" do
        expect(@red_head_duck.perform_quack).to eq "ZhiZhi"
      end
    end
  end

end
