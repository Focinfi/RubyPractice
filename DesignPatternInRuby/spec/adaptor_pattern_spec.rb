require 'adaptor_pattern'
require 'pattern_helper'

RSpec.describe 'Adaptor Pattern' do
  describe OldWorker do
    include OldWorker

    it "has methods: faker_add, faker_subtracte" do
      expect(methods).to be_contain [:faker_add, :faker_subtracte]
    end
  end

  describe WorkerAdaptor do
    include WorkerAdaptor

    it "has methods: add, subtracte" do
      expect(methods).to be_contain [:add, :subtracte]
    end
  end

  describe NewCalculator do
    before :each do
      @new_calculator = NewCalculator.new
    end

    it "has methods: add, subtracte" do
      expect(@new_calculator.methods).to be_contain [:add_calculate, :subtracte_alculate]
    end

    it "raise NoMethodError when extend @new_calculator with OldWorker" do
      @new_calculator.extend(OldWorker)
      expect { @new_calculator.add_calculate }.to raise_error(NoMethodError)
    end

    it "run smoothly when extend @new_calculator with WorkerAdaptor" do
      @new_calculator.extend(WorkerAdaptor)
      expect(@new_calculator.methods).to be_contain [:add, :subtracte]
      expect { @new_calculator.add_calculate }.not_to raise_error
    end
  end
end
