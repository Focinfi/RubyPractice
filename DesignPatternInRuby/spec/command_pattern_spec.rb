require 'command_pattern'

RSpec.describe 'Command Pattern' do

  describe TV do
    it "has default state" do
      expect(TV.new.state).to eq 'closed'
    end
  end

  describe Command do
    it "do nothing when execute" do
      expect(Command.new.execute).to be_nil
    end

    it "do nothing when undo" do
      expect(Command.new.revoke).to be_nil
    end
  end
  
  let(:tv) { TV.new } 

  describe TVOnCommand do
    before do
      tv.state = "closed"
      @tv_on_command = TVOnCommand.new tv
    end

    it "turn TV on when execute" do
      @tv_on_command.execute
      expect(tv.state).to eq 'running'
    end

    it "turn TV down when revoke" do
      @tv_on_command.execute.revoke
      expect(tv.state).to eq 'closed'
    end
  end

  describe TVOffCommand do
    before  do
      tv.state = "closed"
      @tv_off_command = TVOffCommand.new tv
    end

    it "turn TV off when execute" do
      @tv_off_command.execute
      expect(tv.state).to eq 'closed'
    end

    it "turn TV on when undo" do
      @tv_off_command.execute
      @tv_off_command.revoke
      expect(tv.state).to eq 'running'
    end
  end

  describe RemoteController do
    let(:remote_controller) { RemoteController.new } 
    before :each do
      tv.state = "closed"
      remote_controller.add_command_for tv, on: TVOnCommand, off: TVOffCommand
    end

    it "has a commands array" do
      expect(remote_controller.commands[tv][:on].class).to eq TVOnCommand
      expect(remote_controller.commands[tv][:off].class).to eq TVOffCommand
    end

    it "has a commands_done_stack" do
      expect(remote_controller.call_stack).not_to be_nil

      remote_controller.turn_on_for tv
      remote_controller.turn_off_for tv
      expect(remote_controller.call_stack.count).to eq 2
    end

    it "can execute one command passing a device object" do
      remote_controller.turn_on_for tv
      expect(tv.state).to eq 'running'

      remote_controller.turn_off_for tv
      expect(tv.state).to eq 'closed'
    end

    it "can revoke a recentest expected command" do
      remote_controller.turn_on_for tv
      remote_controller.turn_off_for tv

      remote_controller.revoke
      expect(tv.state).to eq 'running'

      remote_controller.revoke
      expect(tv.state).to eq 'closed'

      expect(remote_controller.revoke).to be_nil
    end

    it "has a mode to execute many commands at a time" do
      light = Light.new
      remote_controller.add_mode_for 'Party',
        on: {
          mode_command: PartyOnCommand,
          devices_commands: { tv => TVOnCommand, light => LightOffCommand }
        },
        off: {
          mode_command: PartyOffCommand,
          devices_commands: { tv => TVOffCommand, light => LightOnCommand }
        }

      remote_controller.turn_on_for 'Party'
      expect(tv.state).to eq 'running'
      expect(light.state).to eq 'closed'
    end
  end
end
