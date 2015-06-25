RSpec.describe "Sutb and Mock" do
  before do
    class Painter
      attr_reader :ready

      def draw
        got_a_paint
        @ready = true
      end
    end
  end

  let(:frank) { Painter.new }

  it "Sutb a method not been implemented" do
    allow(frank).to receive(:got_a_paint)
    frank.draw
    expect(frank.ready).to eq true
  end

  it "Mock = stub + expection" do
    expect(frank).to receive(:got_a_paint)
    frank.draw
  end
end
