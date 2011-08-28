require 'controller'


class MyControllerWithUser < ControllerWithUser
  cache_headers :private
end

[:render, :send_file, :send_data].each do |method|
  describe "cache-headers using controller method #{method}" do
    context "with simple controller" do
      subject { ControllerWithUser.new(Object.new) }
      
      it 'should use default' do
        subject.send method, :inline => "asd"
        subject.response.headers.should == {"X-Frame-Options"=>"DENY", "X-Content-Type-Options"=>"nosniff", "X-XSS-Protection"=>"1; mode=block"}
      end
      it 'should use given option' do
        subject.send method, :inline => "asd", :cache_headers => :protected
        subject.response.headers.delete("Date").should_not be_nil
        subject.response.headers.delete("Expires").should_not be_nil
        subject.response.headers.should == {"Cache-Control"=>"private, max-age=0", "X-Frame-Options"=>"DENY", "X-Content-Type-Options"=>"nosniff", "X-XSS-Protection"=>"1; mode=block"}
      end
    end
    
    context "with controller with header configuration" do
      subject { MyControllerWithUser.new(Object.new) }
      
      it 'should use configuration' do
        subject.send method, :inline => "asd"
        subject.response.headers.delete("Date").should_not be_nil
        subject.response.headers.delete("Expires").should_not be_nil
        subject.response.headers.should == {"Pragma"=>"no-cache", "Cache-Control"=>"no-cache, must-revalidate, no-store", "X-Frame-Options"=>"DENY", "X-Content-Type-Options"=>"nosniff", "X-XSS-Protection"=>"1; mode=block"}
      end
      it 'should use given option' do
        subject.send method, :inline => "asd", :cache_headers => :public
        subject.response.headers.delete("Date").should_not be_nil
        subject.response.headers.delete("Expires").should_not be_nil
        subject.response.headers.should == {"Cache-Control"=>"public, max-age=0, no-store", "X-Frame-Options"=>"DENY", "X-Content-Type-Options"=>"nosniff", "X-XSS-Protection"=>"1; mode=block"}
      end
    end
    
    context "with simple controller without user" do
      subject { MyControllerWithUser.new }
      
      it 'should use default' do
        subject.send method, :inline => "asd"
        subject.response.headers.should == {"X-Frame-Options"=>"DENY", "X-Content-Type-Options"=>"nosniff", "X-XSS-Protection"=>"1; mode=block"}
      end
    end
  end
end
