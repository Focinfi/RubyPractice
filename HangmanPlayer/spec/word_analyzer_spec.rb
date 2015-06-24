require 'word_analyzer'

RSpec.describe WordAnalyzer do
  describe "Data Preparatopn" do
    before :context do
      @word_analyzer = WordAnalyzer.new "***"
    end
    context "Word List waiting to filtered" do
      it "has a certain length words' list" do
        words_set = @word_analyzer.words_set
        expect(words_set.map { |word| word.length }.uniq.join.to_i).to eq 3
      end

      it "has a regexp passing guessing result" do
        @word_analyzer.last_guess_result = "A**"
        expect(@word_analyzer.filter_regexp).to eq Regexp.new("A..")
      end

      it "has filtered words_set passing a regepx" do
        @word_analyzer.last_guess_result = "A**"
        expect(@word_analyzer.filtered_words_set.map{ |word| word[0] }.uniq.join).to eq "A"
      end

      it "has a most possible charactors' list words_char_list" do
        expect(@word_analyzer.words_char_list).not_to be_nil
      end

      it "select a most possible charactor" do
        last_char = @word_analyzer.words_char_list.last
        expect(@word_analyzer.guess_a_char).to eq last_char
      end
    end
  end
end
