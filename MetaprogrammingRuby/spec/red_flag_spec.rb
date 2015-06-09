require 'red_flag'

RSpec.describe "Red Flag"do
  it "has a red flag" do
    expect(red_flags.class).to eq Proc
  end

  it "can checkout the red events" do
    expect(red_flags.call).not_to be_nil
  end
end
