module Caculater
  def add(n)
    logger.info("adding...")
    logger.info("logger_id: #{logger.object_id}")
    @number += n 
    self
  end 
end

module Introductioin
  def introduction
    "This calss's object_id is: #{object_id}\n introduction: #{self.description}" 
  end
end

module Log
  class Logger
    def info(s)
      puts "Info: #{s}"
    end 
  end

  # singleton Logger object
  def logger
    @@logger ||= Logger.new
  end
end

class Papers
  include Log
  include Caculater
  extend Introductioin

  def self.description
    "I am a basic Papers"
  end

  def initialize(number)
    @number = number
  end  

  def to_s
    "#{object_id} has #{@number} Papers" 
  end
end

class Book < Papers
  def self.description
    "I am a Book"
  end
end

class Note < Papers
  def self.description
    "I am a Note"
  end

  def writing
    logger.info("I am writing a diary")
    logger.info("logger_id: #{logger.object_id}")
    self
  end
end

book = Book.new(10)

note = Note.new(100)

book.add(1)
note.add(10).add(2)
note.writing

# include Caculater, every instance has its own states(instance variables)
puts book, note

# extend Introductioin, every Class object has these class methods
puts Papers.introduction, Book.introduction, Note.introduction

# extend Log, there only has one Logger instance