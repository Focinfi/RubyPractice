class Observer
  attr_reader :updated_at, :version
  attr_accessor :subjects

  def initialize
    @subjects = []
    @updated_at = Time.now
    @version = 0
  end

  def display
    "Latest data, update time is #{@updated_at}"
  end

  def update
    @version += 1
    @updated_at = Time.now
    display
  end
end

class Subject
  attr_reader :observers

  def initialize
    @observers = []
  end

  def register_obs observer
    unless @observers.include? observer
      observer.subjects << self
      @observers << observer
    end
  end

  def remove_obs observer
    @observers.delete observer
    observer.subjects.delete self
  end

  def notify
    @observers.each(&:update)
  end
end


class NewsSubject < Subject
  attr_reader :state, :readers

  def initialize
    @readers = super
    @state = "No News"
  end
end

class NewsReader < Observer
  attr_reader :name, :subjects

  def initialize
    super
    @name = "new_reader"
  end
end
