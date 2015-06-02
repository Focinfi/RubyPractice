require 'singleton_pattern'

RSpec.describe 'Singleton Pattern' do
  describe Director do
    it "can not access Director.new" do
      expect { Director.new }.to raise_error(NoMethodError)
    end

    it "return a instance of Director by calling Director.chief" do
      expect(Director.chief.class).to eq Director
    end

    it "has only one instance of Director" do
      expect(Director.chief.object_id).to eq Director.chief.object_id
    end
  end
end
