require 'process_support'

RSpec.describe ProcessSupport do
  include ProcessSupport

  describe "Support Utils" do
    context "String Extention" do
      it "can wrap a string with '()' " do
        expect("hello".wrap_with '()').to eq "(hello)"
      end

      it "can select all '*' from 'ab*c*' " do
        expect("ab*c*".select_all "*").to eq ["*", "*"]
      end

      it "can parse a string to hash" do
        expect(parse("{\"hello\": \"world\"}")).to eq ({ "hello" => "world" })
      end

      it "can format data to log" do
        expect(log_for("run", status: "Start", msg: "loading")).to(
            eq("[#{Time.now.to_s}]" + "Action Run => status: Start, msg: loading\n"))
      end

      it "can rescue the exception when parse a invalid josn string to hash" do
        expect(parse "").to eq({})
      end
    end

    context "File Utils" do
      it "can read and write the record file" do
        score = previous_record
        save_new_record "500"
        expect(previous_record).to eq "500"
        save_new_record score
      end

      it "can read and write the game status file" do
        save_game_status({"hello" => "world"})
        expect(parse last_game_status).to eq({"hello" => "world"})
      end
    end

    context "JSON Parse" do
      it "can make a char_list for a hash" do
        words_set = Set.new(["a", "am"])
        expect(make_char_list_for words_set).to eq ["m", "a"]
      end

      it "can extract word array of a certain length" do
        words_hash = make_words_hash_length_of 3
        expect(words_hash["words_set"][0].length).to eq 3
      end

      it "can make Regular expressions, A**** => /A..../" do
        s = "A****"
        expect(make_regexp s).to eq(Regexp.new "A....")
      end

      it "can filter matched words" do
        s = "A**"
        regexp = make_regexp s
        words_hash = make_words_hash_length_of 3
        expect((words_hash["words_set"].filter_by regexp).map { |w| w[0] }.uniq.join).to eq "A"
      end
    end
  end

end
