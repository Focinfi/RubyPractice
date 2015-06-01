require 'pattern_helper'
RSpec.describe PatternHelper do
  context 'Array Extension' do
    it "can check if a array contains another array" do
      expect([1, 2, 3].contain? [1, 2]).to eq true
    end
  end
end

