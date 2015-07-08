require 'constant_lookup'

RSpec.describe "Contant Lookup" do
  include A
  context "Env preparation" do
    it "access A::C" do
      expect(A::C).not_to be_nil
    end

    it "B is A::B"
  end
end
