require File.dirname(__FILE__)+'/spec_helper'
describe 'SpaceHashStruct in chipmunk' do
  describe 'SpaceHash class' do
    it 'can be create' do
      bb_func = Proc.new do |shape|
       	puts "hi" 
      end
      sh = CP::SpaceHash.new(1,2,&bb_func)
      sh.cell_dim.should == 1
      prime_that_fits = 5
      sh.num_cells.should == prime_that_fits
    end

    it 'can have things inserted'
    it 'can lookup query by BB'
  end
end
