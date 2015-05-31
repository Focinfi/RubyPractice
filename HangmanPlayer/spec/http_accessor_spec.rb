require "http_accessor"
require "process_support"

RSpec.describe HttpAccessor do
  include ProcessSupport

  describe "Environment Preparation" do
    it "should access HttpAccessor and Settings" do
      expect(HttpAccessor.new("", "", "")).not_to be_nil
      expect(parse(Settings.actions)["start_game"]).to eq "startGame"
    end
  end

  describe "HttpAccessor POST" do
    before :context do
      @http_accessor = HttpAccessor.new(Settings.player_id,
                                        Settings.base_url,
                                        parse(Settings.actions))
      @http_accessor.set_session_id
    end

    context "Http accessor utils" do

      it "should produce valid json" do
        expect(@http_accessor.json_for(action: @http_accessor.actions["start_game"],
                                       playerId: @http_accessor.player_id)).to(
                               eq ("{\"action\":\"startGame\",\"playerId\":\"#{@http_accessor.player_id}\"}"))
      end

      it "can get a seesion id from server" do
        expect(@http_accessor.session_id).not_to be_nil
      end

      it "can get a new word from server" do
        data = @http_accessor.get_next_word["data"]
        expect(data.keys).to eq ["word", "totalWordCount", "wrongGuessCountOfCurrentWord"]
      end

      it "can post a guess char to server" do
        data = @http_accessor.post_guessed_char_of("A")["data"]
        expect(data.keys).to eq ["word", "totalWordCount", "wrongGuessCountOfCurrentWord"]
      end

      it "can get result of this game from server" do
        data = @http_accessor.get_result["data"]
        expect(data.keys).to eq ["totalWordCount", "correctWordCount", "totalWrongGuessCount", "score"]
      end

      it "can post result to server" do
        data = @http_accessor.submit_result["data"]
        expect(data.keys).to eq ["playerId", "sessionId", "totalWordCount", "correctWordCount", "totalWrongGuessCount", "score", "datetime"]
        expect(data["playerId"]).to eq Settings.player_id
        expect(data["sessionId"]).to eq @http_accessor.session_id
      end
    end
  end
end

