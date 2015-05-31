require 'hangman_player'
require 'process_support'

RSpec.describe HangManPlayer do
  include ProcessSupport
  describe "Environment Preparation" do
    it "can access hang_man_player.rb" do
      expect(HangManPlayer.new("frank").player_id).to eq "frank"
    end

    it "can access process_support" do
      expect("ee*e".select_all "*").to eq ["*"]
    end
  end

  describe "Word Handler" do
    it "should return the count of the *" do
      expect("*****".select_all("*").length).to eq 5
    end
  end

  describe "Player Play Control" do
    before :context do
      @player = HangManPlayer.new(Settings.player_id)
      @player.start
    end

    context "Get Game data from server with HttpAcessor" do
      it "should set @number_of_words_to_guess and @number_of_guess_allowed_for_each_word when start" do
        expect(@player.number_of_words_to_guess).not_to be_nil
        expect(@player.number_of_guess_allowed_for_each_word).not_to be_nil
      end

      it "should return a new word if call next_word" do
        expect(@player.next_word).not_to be_nil
      end

      it "should get a result" do
        expect(@player.game_result["data"]["score"]).not_to be_nil
      end
    end

    context "Save Game Status" do
      it "should save game status when a something goes wrong or completed the game" do
        @player.over
        expect(parse(last_game_status).keys).to eq %w{ playerId
                                                       sessionId
                                                       numberOfWordsToGuess
                                                       numberOfGuessAllowedForEachWord
                                                       completed }
      end
    end
  end
end

