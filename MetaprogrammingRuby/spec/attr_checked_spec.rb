require 'attr_checked'
require 'helper'

RSpec.describe AttrChecked do
  class MyClass; end

  let(:env) { MyClass.new }

  def check_add_checked_attribute attr
    attr_set = "#{attr}="
    expect(env.methods).to be_contain [attr.to_sym, attr_set.to_sym]
    expect { env.send attr_set, false }.to raise_error(ArgumentError)
  end

  describe "V1: eval()" do
    def add_checked_attribute clazz, attr
      code = %{
        class #{clazz}
          def #{attr.to_s}
            @#{attr.to_s}
          end

          def #{attr.to_s}= value
            raise ArgumentError unless value
            @#{attr.to_s} = value
          end
        end
      }
      eval code
    end

    before do
      add_checked_attribute MyClass, :apple
    end

    it "add_checked_attribute" do
      check_add_checked_attribute :apple
    end
  end

  describe "V2 Take eval() out" do
    Class.class_eval { include AttrChecked::V2 }
    MyClass.class_eval do
      add_checked_attribute :car
    end

    it "add_checked_attribute" do
      check_add_checked_attribute :car
    end
  end

  describe "V3: Add validation" do
    Class.class_eval { include AttrChecked::V3 }
    MyClass.class_eval do
      add_checked_attribute :tip do |value|
        value.to_s.length < 5
      end
    end

    it "add_checked_attribute" do
      check_add_checked_attribute :tip
    end

    it "permit a valid attr to be set" do
      expect { env.tip = "Foci" }.not_to raise_error
    end
  end

  describe "V4: Add included method" do
    MyClass.class_eval do
      include AttrChecked::V4
      add_checked_attribute :wine do |value|
        value == "Sake"
      end
    end

    it "add_checked_attribute" do
      check_add_checked_attribute :wine
    end

    it "permit a valid attr to be set" do
      expect { env.wine = "Sake" }.not_to raise_error
    end
  end

end
