class String
  def blank_or_new_line?
    " " == self || "\n" == self
  end
end

module IOForParseWord
  def greet
    puts "Please input C language Code: (end whith '/END' in a new line)"
  end

  def get_source  
    code = ""  
    loop do  
      temp = gets    
      if temp.end_with? "\/END\n" 
        break
      else
        code << temp        
      end
    end
    code
  end

  def save_source(code)
    file_name = "CLangSrc#{Time.now}.txt"
    File.open(file_name, "w") { |file| file.puts code }
    file_name
  end

  def save_res(file_name, res_arr)
    File.open(file_name, "w") { |file| file.puts res_arr.join("\n") }
  end

  def parse_word(category_num, code)
    "(#{category_num}, \'#{code}\')"
  end
end

module ConstantVal
  REVERSE = 1
  IDENTIFIER = 2
  DIGITAL = 3
  BOUNDARY = 4
  OPERATOR = 5

  SINGLE_LLINE_REX = /\/\/.*/s
  MUTIL_LINE_REX = /\/\*.*\*\//m

  REVERSE_ARR = %w{
    auto break case char const 
    continue default do double else
    enum extern float for goto
    if int long redister return
    short signed sizeof static struct 
    switch typedef union unsigned void 
    volatile while main
  }  

  LETTER_ARR = ('a'..'z').to_a + ('A'..'Z').to_a
  NUM_ARR = ('0'..'9').to_a
  BOUNDARY_ARR = %w{, ; { } ( ) : " " ' ' #}.concat([' '])
  OPERATOR_ARR = %w{+ - * / = | & ! < >}
end

class CLangLexer
  include IOForParseWord, ConstantVal
  attr_writer :code_arr
  attr_reader :res_arr
  def initialize
    @code_arr = []
    @start_index = 0
    @cur_index = 0;
    @res_arr = []
  end

  def run
    greet
    src_file_name = save_source get_source
    clean(IO.read(src_file_name))
    analysis_new 
    save_res(src_file_name << "_resoult.text", @res_arr)
  end
  
  def word
    @code_arr[@start_index...@cur_index].join
  end

  def clean(code_str)
    @code_arr =
      code_str.gsub(SINGLE_LLINE_REX, '')
              .gsub(MUTIL_LINE_REX, '')
              .squeeze(" ")
              .chars
  end

  def go_on_analysis(category, options = {})
    @cur_index += 1 if options[:inc] == true
    puts parse_word(category, word)
    @res_arr << parse_word(category, word)
    @start_index = @cur_index
    analysis_new
  end

  def go_next_char
    @cur_index += 1
    @start_index += 1
  end

  def analysis_new
    return if @start_index > @code_arr.length - 1

    if @code_arr[@start_index].blank_or_new_line?
      go_next_char      
      analysis_new
      return
    end
    c = @code_arr[@start_index]
    if LETTER_ARR.concat(['_']).include?(c) then handle_letter
    elsif NUM_ARR.include?(c) then handle_num
    elsif BOUNDARY_ARR.include?(c) then handle_bandary
    elsif OPERATOR_ARR.include?(c) then handle_operator
    else 
      go_next_char
    end
  end

  def handle_letter
    loop do
      if LETTER_ARR.include?(@code_arr[@cur_index]) || 
        NUM_ARR.include?(@code_arr[@cur_index])
        @cur_index += 1
      else
        break
      end
    end

    if REVERSE_ARR.include? word
      gategory = REVERSE
    else
      gategory = IDENTIFIER
    end
    go_on_analysis(gategory)   
  end

  def handle_num
    loop do
      if NUM_ARR.include?(@code_arr[@cur_index])
        @cur_index += 1
      else
        break
      end
    end
    go_on_analysis(DIGITAL)
  end

  def handle_bandary
    go_on_analysis(BOUNDARY, inc: true)
  end

  def handle_operator
    loop do 
      # puts "@start= #{@start_index}, @cur_index= #{@cur_index}"
      if @cur_index - @start_index > 2
        @cur_index -= 1
        break
      elsif OPERATOR_ARR.include?(@code_arr[@cur_index])
        @cur_index += 1
      else
        break
      end
    end
    go_on_analysis(OPERATOR)
  end
end




