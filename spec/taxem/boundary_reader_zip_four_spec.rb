require 'spec_helper'

describe Taxem::BoundaryReaderZipFour do

  before(:all) do
    path_to_csv = boundary_data
    @boundary_reader = Taxem::BoundaryReaderZipFour.new(path_to_csv)
  end

  subject { @boundary_reader }

  it { should respond_to :boundaries }
  its(:records_in_file) { should == 591393 }
  its(:record_count) { should == 76871 }

  describe 'boundaries' do
    subject { @boundary_reader.boundaries }
    it { should have_at_least(1).items }
    it { should have(76871).items }

    it 'has valid boundary objects' do
      subject.each do |boundary|
        boundary.record_type.should == '4'
        boundary.beginning_effective_date.should <= Date.today
        boundary.ending_effective_date.should >= Date.today
      end
    end

    it 'has zip codes' do
      subject.each do |boundary|
        boundary.zip_extension_low.should_not == ''
        boundary.zip_extension_high.should_not == ''
      end
    end

    it 'has no composite SER code' do
      subject.each do |boundary|
        boundary.composite_ser_code.should == ""
      end
    end

  end
end



