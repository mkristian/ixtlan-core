require 'fileutils'
Given /^I create new rails application with template "(.*)"$/ do |template|
  name = template.sub(/.template$/, '')
  directory = File.join('target', name)

  rails_version = '3.0.5'

  command = "#{ENV['GEM_HOME']}/bin/rmvn"
  jruby = File.read(command).split("\n")[0].sub(/^#!/, '')
  args = "rails new #{directory} -f -m templates/#{template} -- -DrailsVersion=#{rails_version} -Dgem.home=#{ENV['GEM_HOME']} -Dgem.path=#{ENV['GEM_PATH']} -Dplugin.version=0.26.0-SNAPSHOT"
  FileUtils.rm_rf(directory)

  full = "#{jruby} #{command} #{args}"
  # puts full
  system full
  
  @result = File.read("target/#{name}/output.log")
  puts @result
end

Then /^the output should contain \"(.*)\"$/ do |expected|
  expected.split(/\"?\s+and\s+\"?/).each do |exp|
    puts exp
    (@result =~ /.*#{exp}.*/).should_not be_nil
  end
end

