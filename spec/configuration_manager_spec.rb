require 'ixtlan/core/configuration_manager'
require 'slf4r/ruby_logger'
require 'active_support/core_ext/string'

class ConfigModel

  def self.instance
    @called = called + 1
    @instance ||= self.new
  end

  def self.after_save(method)
    @method = method.to_sym
  end

  def self.save_method
    @method
  end

  def self.called
    @called ||= 0
  end

  def save
    send self.class.save_method if self.class.save_method
  end
end

describe Ixtlan::Core::Configuration::Manager do

  before :all do
    ConfigModel.send :include, Ixtlan::Core::Configuration::Module
  end

  it "should register listeners and fire change events" do
    count = 0
    clazz = nil
    subject.register("counter") do |c|
      count += 1
      clazz = c.class
    end
    subject.setup(:config_model)
    subject.configure
    count.should == 1
    clazz.should == ConfigModel
  end
  
  it "should use instance method only once per thread" do
    base = ConfigModel.called > 0 ? ConfigModel.called : 1
    ConfigModel.instance
    ConfigModel.called.should == base
    ConfigModel.instance
    ConfigModel.called.should == base
    ConfigModel.clear_instance  # clear thread local variable
    ConfigModel.instance
    ConfigModel.called.should == 1 + base
  end

end
