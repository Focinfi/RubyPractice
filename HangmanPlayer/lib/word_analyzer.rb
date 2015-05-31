require_relative './process_support.rb'

class WordAnalyzer
  include ProcessSupport

  attr_reader :words_set, :words_char_list
  attr_accessor :last_guess_result

  def initialize word
    @word = word
    @length = word.length
    @words_set = make_words_hash_length_of(@length)["words_set"]
    @words_char_list = make_char_list_for @words_set
    @chars_did_used = Set.new
    @number_of_right
    @number_of_wrong = 0
    @last_guess_result = word
  end

  def analyze data = {}
    guess_result = data["word"]
    @number_of_wrong = data["wrongGuessCountOfCurrentWord"]
    @number_of_right = @length - guess_result.select_all("*").length
    if @last_guess_result != guess_result
      update_words_data_for guess_result
    end
  end

  def continue?
    !@words_char_list.empty?
  end

  def update_words_data_for guess_result
    @last_guess_result = guess_result
    @words_set = filtered_words_set
    @words_char_list =
      (Set.new(make_char_list_for @words_set) - @chars_did_used).to_a
  end

  def filter_regexp
    make_regexp @last_guess_result
  end

  def filtered_words_set
    @words_set.filter_by filter_regexp
  end

  def guess_a_char
    output log_for "Make Char List", words_char_list: @words_char_list.last(5)
    @chars_did_used << @words_char_list.last
    @words_char_list.pop
  end

end
