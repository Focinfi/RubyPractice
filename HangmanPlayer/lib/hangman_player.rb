require_relative './process_support.rb'
require_relative './http_accessor.rb'
require_relative './word_analyzer.rb'
require_relative '../config/settings.rb'

class HangManPlayer
  include ProcessSupport

  attr_reader :player_id,
              :number_of_words_to_guess,
              :number_of_guess_allowed_for_each_word

  def initialize player_id
    @player_id = player_id
    @total_word_count = 0
    @http_accessor = HttpAccessor.new(@player_id, Settings.base_url, Settings.actions)
    @completed = false
  end

  def play
    begin
      start
      loop do
        break if @number_of_words_to_guess <= @total_word_count
        guess next_word
      end
      over
    rescue Exception => e
      @completed = false
      record log_for "Play", status: "Faild", error: e.to_s
    end
  end

  def start
    if data = has_uncompleted_game?
      @http_accessor.session_id = data["sessionId"]
    else
      data = @http_accessor.set_session_id["data"]
    end
    output log_for "Start Game"
    @number_of_words_to_guess = data["numberOfWordsToGuess"]
    @number_of_guess_allowed_for_each_word  = data["numberOfGuessAllowedForEachWord"]

    record log_for "New Game",
                    player_id: @player_id,
                    total_word_count: @total_word_count,
                    number_of_words_to_guess: @number_of_words_to_guess,
                    number_of_guess_allowed_for_each_word: @number_of_guess_allowed_for_each_word
  end

  def has_uncompleted_game?
    data = parse last_game_status
    if @player_id == data["playerId"] && !data["completed"]
      data
    else
      false
    end
  end

  def next_word
    data = @http_accessor.get_next_word["data"]
    @total_word_count = data["totalWordCount"]

    output log_for "New Word", word: data["word"],
                               total_word_count: @total_word_count

    @completed = @total_word_count >= @number_of_words_to_guess                       
    save_game_status({ "playerId" => @player_id,
                       "sessionId" => @http_accessor.session_id,
                       "date" => Time.now.to_s,
                       "numberOfWordsToGuess" => @number_of_words_to_guess,
                       "numberOfGuessAllowedForEachWord" => @number_of_guess_allowed_for_each_word,
                       "completed" => @completed})
    data["word"]
  end

  def guess word
    wrong_guess_count_of_current_word = 0
    @word_analyzer = WordAnalyzer.new word

    loop do
      next_guess_char = @word_analyzer.guess_a_char
      break unless next_guess_char

      output log_for "Guess", next_guess_char: next_guess_char

      data = @http_accessor.post_guessed_char_of(next_guess_char)["data"]

      output log_for "Result", word: data["word"]

      if guessed? word or wrong_guess_count_of_current_word >= @number_of_guess_allowed_for_each_word
        break
      end

      @word_analyzer.analyze data

      output log_for "Guess", words_set: @word_analyzer.words_set.first(5)
      output log_for "Continue:", continue: @word_analyzer.continue?

      wrong_guess_count_of_current_word = data["wrongGuessCountOfCurrentWord"]

      record log_for "Guess Word",
                      guess: next_guess_char,
                      result: data["word"],
                      wrong_guess_count_of_current_word: wrong_guess_count_of_current_word

    end

  end

  def guessed? word
    word.to_s.select_all("*").length == 0
  end

  def over
    score = game_result["data"]["score"]

    output log_for "Game Over",
                    player_id: @player_id,
                    score: score,
                    number_of_words_to_guess: @number_of_words_to_guess,
                    total_word_count: @total_word_count,
                    date: Time.now.to_s


    if @completed && new_record?(score)
      @http_accessor.submit_result
      save_new_record score
    end
  end

  def game_result
    @http_accessor.get_result
  end

  def new_record? score
    score.to_i > previous_record.to_i
  end

end
