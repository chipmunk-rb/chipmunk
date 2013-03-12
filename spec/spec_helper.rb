# require 'rspec'
$:.unshift File.join(File.dirname(File.dirname(__FILE__)), 'lib')

require 'chipmunk'

# require 'chipmunk/unsafe'
include CP

# TODO how to get this in rspec nicely?
def check_accessor(let_name, accessor_name, value)
  it "can set / get #{accessor_name}" do
    object = self.send(let_name)
    object.public_methods.should include(accessor_name)
    object.public_methods.should include("#{accessor_name}=".to_sym)
    object.send("#{accessor_name}=", value)
    object.send("#{accessor_name}").should == value
  end
end
