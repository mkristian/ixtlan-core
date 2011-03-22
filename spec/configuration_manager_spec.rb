require 'ixtlan/core/configuration_manager'
require 'slf4r/ruby_logger'

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

describe Ixtlan::Core::ConfigurationManager do

  before :all do
    ConfigModel.send :include, Ixtlan::Core::ConfigurationManager
  end

  it "should register listeners and fire change events" do
    count = 0
    ConfigModel.instance.register("counter") do
      count += 1
    end
    ConfigModel.instance.save
    count.should == 1
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
