require "minitest/autorun"
require './clang_lexer.rb'
class TestCLangLexer < MiniTest::Unit::TestCase
  def setup
    @clang_lexer = CLangLexer.new
  end

  def test_clean_the_comments
    comment_code = <<-COMMENT_CODE
      //this is a single line of comments

      /*this is a 
        multi-row of */ 
        commnents
      */      
    COMMENT_CODE
    assert [], @clang_lexer.clean(comment_code)
  end

  def analysis(src)
    @clang_lexer.code_arr = @clang_lexer.clean(src)
    @clang_lexer.analysis_new
  end

  def assert_res_arr(expected_res_arr)
    assert expected_res_arr, @clang_lexer.res_arr
  end

  def test_handle_reverse
    analysis "int main"    
    assert_res_arr ["(1, 'int')", "(1, 'main')"]
  end

  def test_handle_identifier
    analysis "int a"
    assert_res_arr ["(1, 'int')", "(2, 'a')"]
  end

  def test_handle_digital
    analysis " 123 234 "
    assert_res_arr ["(3, '123')", "(3, '234')"]
  end

  def test_handle_boundary
    analysis " ( }; "
    assert_res_arr ["(4, '(')", "(4, '})", "(4, ';')"]
  end

  def test_handle_opterator
    analysis " + *= ++="
    assert_res_arr ["(5, '+')", "(5, '*=')", "(5, '++')", "(5, '=')"]
  end
end