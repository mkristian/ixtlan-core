require 'controller'

shared_examples 'a X-Headers' do

  it 'should be able to switch off' do
    subject.send method, :inline => "asd", :x_frame_headers => :off, :x_content_type_headers => :off, :x_xss_protection_headers => :off
    subject.response.headers.should == {}
  end

end

class MyController < Controller
  x_frame_headers :sameorigin
  x_content_type_headers :off
  x_xss_protection_headers :disabled
end

[:render, :send_file, :send_data].each do |method|
  describe "x-headers using controller method #{method}" do
    context "with simple controller" do
      before do
        Rails.configuration.x_frame_headers = nil
        Rails.configuration.x_content_type_headers = nil
        Rails.configuration.x_xss_protection_headers = nil
      end
      subject { Controller.new }
      
      it 'should use default' do
        subject.send method, :inline => "asd"
        subject.response.headers.should == {"X-Frame-Options"=>"DENY", "X-Content-Type-Options"=>"nosniff", "X-XSS-Protection"=>"1; mode=block"}
      end
      
      it_behaves_like "a X-Headers" do
        let(:method) { method }
      end
    end
    
    context "with controller with header configuration" do
      before do
        Rails.configuration.x_frame_headers = nil
        Rails.configuration.x_content_type_headers = nil
        Rails.configuration.x_xss_protection_headers = nil
      end
      subject { MyController.new }
      
      it 'should use configuration' do
        subject.send method, :inline => "asd"
        subject.response.headers.should == {"X-Frame-Options"=>"SAMEORIGIN", "X-XSS-Protection"=>"0"}
      end
      
      it_behaves_like "a X-Headers" do
        let(:method) { method }
      end
    end
    
    context "with simple controller with rails configuration" do
      before do
        Rails.configuration.x_frame_headers = :sameorigin
        Rails.configuration.x_content_type_headers = :off
        Rails.configuration.x_xss_protection_headers = :disabled
      end
      subject { Controller.new }
      
      it 'should use configuration' do
        subject.send method, :inline => "asd"
        subject.response.headers.should == {"X-Frame-Options"=>"SAMEORIGIN", "X-XSS-Protection"=>"0"}
      end
      
      it_behaves_like "a X-Headers" do
        let(:method) { method }
      end
    end
  end
end
