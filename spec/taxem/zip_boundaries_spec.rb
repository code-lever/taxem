require 'spec_helper'
require 'taxem/boundary_shared_example'

describe Taxem::ZipBoundaries do

  let(:b1) do
    b1 = double("Boundary")
    b1.stub(:zip_code_low).and_return("12345")
    b1.stub(:zip_code_high).and_return("12347")
    b1.stub(:beginning_effective_date).and_return(Date.new(2001, 11, 11))
    b1.stub(:ending_effective_date).and_return(Date.new(2999, 12, 31))
    b1
  end

  describe "b1" do
    subject { b1 }
    it_behaves_like "a boundary for ZipBoundaries"
  end

  let(:b2) do
    b2 = double("Boundary")
    b2.stub(:zip_code_low).and_return("22345")
    b2.stub(:zip_code_high).and_return("22347")
    b2.stub(:beginning_effective_date).and_return(Date.new(2001, 11, 11))
    b2.stub(:ending_effective_date).and_return(Date.new(2999, 12, 31))
    b2
  end

  describe "b2" do
    subject { b2 }
    it_behaves_like "a boundary for ZipBoundaries"
  end

  let(:boundary_not_effective) do
    boundary_not_effective = double("Boundary")
    boundary_not_effective.stub(:zip_code_low).and_return("32345")
    boundary_not_effective.stub(:zip_code_high).and_return("32347")
    boundary_not_effective.stub(:beginning_effective_date).and_return(Date.new(2001, 11, 11))
    boundary_not_effective.stub(:ending_effective_date).and_return(Date.new(2006, 12, 31))
    boundary_not_effective
  end

  describe "boundary_not_effective" do
    subject { boundary_not_effective }
    it_behaves_like "a boundary for ZipBoundaries"
  end

  it 'accepts a date in the initializer' do
    Taxem::ZipBoundaries.new(Date.new(2011, 11, 11)).date.should == Date.new(2011,11,11)
  end

  describe "#for_zip" do
    it "returns nil if passed 'unknown'" do
      subject.for_zip('unknown').should be_nil
    end
  end

  describe "#add_boundary" do
    it "raises an error is a boundary with the same zip is added a second time" do
      subject.add_boundary(b1)
      expect {subject.add_boundary(b1)}.to raise_error Taxem::DuplicateZipCodeError
    end

    context "Boundary 1 added" do
      subject { Taxem::ZipBoundaries.new.add_boundary(b1) }
      it "finds b1 zip codes" do
        [12345, 12346, 12347].each do |zip|
          subject.for_zip(zip).should == b1
        end
      end
      it "doesn't find the b1 + 1 zip code" do
        subject.for_zip(22348).should == nil
      end
    end

    context "boundary not effective added" do
      subject { Taxem::ZipBoundaries.new.add_boundary(boundary_not_effective) }
      it "doesn't find the boundary not effective zip codes" do
        [32345, 32346, 32347].each do |zip|
          subject.for_zip(zip).should be_nil
        end
      end
    end
  end


  describe "#add_boundaries" do
    context "Boundary 1 and boundary 2 added as an array" do
      subject { Taxem::ZipBoundaries.new.add_boundaries([b1, b2]) }
      it "finds the b1 zip codes" do
        [12345, 12346, 12347].each do |zip|
          subject.for_zip(zip).should == b1
        end
      end
      it "finds the b2 zip codes" do
        [22345, 22346, 22347].each do |zip|
          subject.for_zip(zip).should == b2
        end
      end
      it "doesn't find the b1 + 1 zip code" do
        subject.for_zip(22348).should == nil
      end
    end
  end
end
