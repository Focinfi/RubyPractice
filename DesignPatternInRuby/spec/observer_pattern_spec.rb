require 'observer_pattern'
require 'pattern_helper'

RSpec.describe 'ObserverPattern' do
  describe Observer do
    let(:obs) { Observer.new }

    context "Display data" do
      it "display some info contain the update time" do
        expect(obs.display).to eq "Latest data, update time is #{obs.updated_at}"
      end
    end
  end

  describe Subject do
    let(:subject) { Subject.new }

    context "Basic interface" do
      it "contains basic methods" do
        expect(subject.methods).to be_contain [:register_obs, :remove_obs, :notify]
      end

      it "has a empty observers array" do
        expect(subject.observers).to be_empty
      end

      it "add a observer to observers array" do
        expect {
          subject.register_obs Observer.new
        }.to change(subject.observers, :count).by(1)
      end

      it "remove a observer from a observers array" do
        obs = Observer.new
        subject.register_obs obs
        expect {
          subject.remove_obs obs
        }.to change(subject.observers, :count).by(-1)
      end

      it "notify every observer that data changed" do
        obs = Observer.new
        another = Observer.new
        subject.register_obs obs
        subject.register_obs another
        expect {
          subject.notify
        }.to change(obs, :version).by(1)

        expect {
          subject.notify
        }.to change(another, :version).by(1)
      end
    end
  end

  describe NewsReader do
    let(:news_reader) { NewsReader.new }

    context "Basic information" do
      it "has a name" do
        expect(news_reader.name).not_to be_nil
      end

      it "subscribe a news_reader" do
        news_subject = NewsSubject.new
        news_subject.register_obs news_reader
        expect(news_reader.subjects).to eq [news_subject]
      end
    end

    context "Notify observers to redislay thier data" do
      it "update version" do
        expect {
          news_reader.update
        }.to change(news_reader, :version).by(1)
      end

      it "display infomation" do
        expect(news_reader.display).to eq "Latest data, update time is #{news_reader.updated_at}"
      end
    end
  end

  describe NewsSubject do

    let(:news_subject) { NewsSubject.new }

    context "Basic information" do
      it "has state" do
        expect(news_subject.state).to eq "No News"
      end

      it "has some readers" do
        expect(news_subject.readers).not_to be_nil
      end
    end

    context "Readers control" do
      let(:reader_one) { NewsReader.new }
      let(:reader_two) { NewsReader.new }

      it "register a reader" do
        expect {
          news_subject.register_obs reader_one
        }.to change(news_subject.observers, :count).by(1)
      end

      it "don't add a reader if it has subscribe" do
        news_subject.register_obs reader_one
        expect {
          news_subject.register_obs reader_one
        }.to change(news_subject.observers, :count).by(0)
      end

      it "remove a reader" do
        news_subject.register_obs reader_one
        expect {
          news_subject.remove_obs reader_one
        }.to change(news_subject.observers, :count).by(-1)
      end

      it "norify readers to update there data" do
        news_subject.register_obs reader_one
        news_subject.register_obs reader_two
        expect {
          news_subject.notify
        }.to change(reader_one, :version).by(1)
      end
    end
  end
end
