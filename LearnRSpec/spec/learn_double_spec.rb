RSpec.describe "double" do
  context "Make a double object" do
    it "return a object" do
      expect(double("book")).not_to be_nil
    end

    it "return a instance" do
      expect(instance_double("Book", pages: 250).pages).to eq 250
    end
  end

  context "Give double a method" do
    let(:book) { double }
    let(:library) { double }

    it "library.has return book" do
      allow(library).to receive(:has) { book }
      expect(library.has).to eq book
    end
  end
end
