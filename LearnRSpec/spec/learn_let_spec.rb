RSpec.describe "let and let!" do
  context "Lazy invoke" do
    base = 0

    before :each do
      base = 0
    end

    let(:counter) { base += 1 }

    it "didn't invoke before we call it" do
      expect(base).to eq 0
    end

    it "invoke when we call it" do
      expect(counter).to eq 1
    end

    it "invoke only once in a example" do
      expect(counter).to eq 1
      expect(counter).to eq 1
    end
  end

  context "Run as defining" do
    base = 0

    before :each do
      base = 0
    end

    let!(:counter) { base += 1 }

    it "invoke before we call it" do
      expect(base).to eq 1
    end

    it "didn't invoke when we call it in a example" do
      expect(counter).to eq 1
      expect(counter).to eq 1
    end
  end
end

