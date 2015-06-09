class CleanRoom < BasicObject
end

DATA_EVENTES_DIR = './data/events/'

def red_flags
  lambda {
    setups = []
    events = {}
    flags = []

    Kernel.send :define_method, :setup do |&block|
      setups << block
    end

    Kernel.send :define_method, :event do |name, &block|
      events[name] = block
    end

    Kernel.send :define_method, :each_event do |&block|
      events.each_pair do |name, event|
        block.call(name, event)
      end
    end

    Kernel.send :define_method, :each_setup do |&block|
      setups.each do |setup|
        block.call setup
      end
    end

    Kernel.send :define_method, :events_files do
        Dir.new(DATA_EVENTES_DIR).select { |d| d =~ /_events.rb$/ }.
          map { |d| DATA_EVENTES_DIR + d }
    end

    events_files.each do |file|
      setups.clear
      events.clear

      load file
      env = CleanRoom.new
      each_event do |name, event|
        each_setup { |setup| env.instance_eval &setup }
        flags << "ALERT: #{name}." if env.instance_eval &event
      end
    end

    flags
  }
end
