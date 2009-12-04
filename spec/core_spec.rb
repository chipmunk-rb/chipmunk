require File.dirname(__FILE__)+'/spec_helper'
describe 'CP module' do
  it 'can give a version' do
    v = CP::VERSION
    # 5.0.0
    v.split(".").size.should == 3
  end
end
