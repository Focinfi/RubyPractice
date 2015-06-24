class Device
  attr_accessor :state

  def initialize
    @state = 'closed'
  end

  def on
    @state = 'running'
  end

  def off
    @state = 'closed'
  end
end

class TV < Device
end

class Light < Device
end

class Command
  def execute
  end

  def revoke
  end
end

class OnCommand < Command
  def initialize device
    @device = device
  end

  def execute
    @device.on
    self
  end

  def revoke
    @device.off
    self
  end
end

class OffCommand < Command
  def initialize device
    @device = device
  end

  def execute
    @device.off
    self
  end

  def revoke
    @device.on
    self
  end
end

class TVOnCommand < OnCommand
end

class TVOffCommand < OffCommand
end

class LightOnCommand < OnCommand
end

class LightOffCommand < OffCommand
end

class ModeCommand
  def initialize devices_commands = {}
    @devices = []
    devices_commands.each do |device, command|
      @devices << command.new(device)
    end
  end

  def execute
    @devices.each(&:execute)
  end

  def revoke
    @devices.each(&:revoke)
  end
end

class PartyOnCommand < ModeCommand
end

class PartyOffCommand < ModeCommand
end

class RemoteController
  attr_reader :commands, :call_stack

  def initialize
    @commands = Hash.new do |h, k|
      h[k] = Hash.new do |commands, type|
        commands[type] = Command.new
      end
    end
    @call_stack = []
  end

  def add_mode_for mode, commands = {}
    @commands[mode][:on] = commands[:on][:mode_command].new commands[:on][:devices_commands]
    @commands[mode][:off] = commands[:off][:mode_command].new commands[:off][:devices_commands]
  end

  def add_command_for device, commands = {}
    @commands[device][:on] = commands[:on].new device if commands[:on]
    @commands[device][:off] = commands[:off].new device if commands[:off]
  end

  def turn_on_for device
    execute_to device, :on
  end

  def turn_off_for device
    execute_to device, :off
  end

  def execute_to device, type
    if command = @commands[device]
      command[type].execute
      @call_stack << command[type]
    end
  end

  def revoke
    last_command = @call_stack.pop
    last_command.revoke if last_command
  end
end
