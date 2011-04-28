=begin
# Beoran: space has not supported for now.

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

    it 'can lookup query by BB empty' do
      bb_func = Proc.new do |shape|
       	puts "hi" 
      end
      sh = CP::SpaceHash.new(1,2,&bb_func)
      bb = BB.new(1,2,3,4)

      objects = sh.query_by_bb(bb)
      objects.size.should == 0

    end

    it 'can have things inserted' do
      bb_func = Proc.new do |shape|
       	puts "hi" 
      end
      sh = CP::SpaceHash.new(1,2,&bb_func)
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2

      sh.insert(s, s.bb)
      # TODO assert that its there
    end

    it 'can have things removed' do
      bb_func = Proc.new do |shape|
       	puts "hi" 
      end
      sh = CP::SpaceHash.new(1,2,&bb_func)
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2

      # TODO assert that its there
      sh.insert(s, s.bb)

      sh.remove(s)
      # TODO assert that its not there
    end

  end
end
=end