require "json"
require_relative "../config/settings.rb"

class String
  def wrap_with b
    self.insert(0, b[0]).insert(length, b[1])
  end

  def select_all target
    self.chars.select { |c| c == target }
  end

  def blank?
    self == ""
  end
end

class Array
  def filter_by regexp
    self.select do |i|
      i =~ regexp
    end
  end
end

class Set
  def filter_by regexp
    self.select do |i|
      i =~ regexp
    end
  end
end

class Hash
  def to_s
    self.to_a.map { |item| "#{item.first.to_s}: #{item[1..-1].join(", ")}" }.join(", ")
  end
end

module ProcessSupport
  APP_ROOT = "#{__dir__.split('/')[0...-1].join('/')}"
  LOG_FILE_PATH = "#{APP_ROOT}/log/hangman_player.log"
  RECORD_FILE_PATH = "#{APP_ROOT}/tmp/record.tmp"
  GAME_STATUS_FILE_PATH = "#{APP_ROOT}/tmp/game_status.tmp"
  WORDS_DATA_DIRECTORY = "#{APP_ROOT}/data"
  WORDS_TEXT_FILE_PATH = "#{WORDS_DATA_DIRECTORY}/words.txt"
  WORDS_JSON_FILE_PATH = "#{WORDS_DATA_DIRECTORY}/words.json"

  def make_words_from dir = "dictionary"
    words_json_file = WORDS_JSON_FILE_PATH
    words_text_file = WORDS_TEXT_FILE_PATH
    words = Hash.new { |h, k| h[k] = { char_list: [], words_set: Set.new }}
    File.open(words_text_file, 'r') do |file|
      file.each_line do |line|
        word = line.to_s.chomp
        next if word.blank? or word.match(/[^a-zA-Z]/)
        words[word.length][:words_set] << word.upcase
      end
    end

    words.each_key do |key|
      hash = words[key]
      words[key][:words_set] = hash[:words_set].to_a
      words[key][:char_list] = make_char_list_for hash[:words_set]
    end

    write_to words_json_file, words.to_json
  end

  def make_char_list_for words_set
    frenquency = Hash.new(0)
    return [] unless words_set

    words_set.each do |word|
      word.to_s.chars.uniq.each do |char|
        frenquency[char] += 1
      end
    end

    sorted = frenquency.sort_by { |char, count| count }
    sorted.map { |arr| arr[0] }
  end

  def make_regexp s
    Regexp.new s.tr("*", ".")
  end

  def read_from file_path
    File.open(file_path, 'r') do |file|
      file.gets
    end
  end

  def write_to file_path, content = nil, mode = 'w'
    File.open(file_path, mode) do |file|
      file.write content
    end
  end

  def output log
    puts log
  end

  def record log, file = LOG_FILE_PATH
    # output log
    write_to LOG_FILE_PATH, log, mode = 'a'
  end

  def previous_record
    read_from RECORD_FILE_PATH
  end

  def save_new_record score
    write_to RECORD_FILE_PATH, score.to_s
  end

  def last_game_status
    read_from GAME_STATUS_FILE_PATH
  end

  def save_game_status data = h
    write_to GAME_STATUS_FILE_PATH, data.to_json
  end

  def make_words_hash_length_of length
    words_hash = parse read_from WORDS_JSON_FILE_PATH
    words_hash[length.to_s]
  end

  def parse json_str
    begin
      JSON.parse(json_str)
    rescue Exception
      Hash.new
    end
  end

  def log_for action, msg = {}
    Time.now.to_s.wrap_with('[]') << "Action #{action.capitalize} => " << msg.to_s << "\n"
  end

  def prompt *opts
    opt_keys = opts.map { |opt| opt[0].upcase }
    prompt_msg = opts.map { |opt| "Type #{opt.capitalize.wrap_with '()'} to #{opt.downcase}" }.join(', ') << opt_keys.join(' or ').wrap_with('()')

    selection = ''
    loop do
      puts prompt_msg
      selection = gets.chomp
      break if opt_keys.include? selection
    end

    yield selection
  end

  def process action
    record log_for action, status: 'Starting'
    begin
      yield
    rescue Exception => e
      record log_for action, status: 'Failed', error: e.to_s
      handle_exception
      retry
    end
    record log_for action, status: 'Done'
  end

  def handle_exception
    prompt 'Exit', 'Retry' do |selection|
      selection ||= 'E'
      raise if selection == 'E'
    end
  end

end


