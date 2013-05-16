require 'spec_helper'

describe Taxem::BoundaryReader do

  before(:all) do
    path_to_csv = boundary_data
    @boundary_reader = Taxem::BoundaryReader.new(path_to_csv)
  end

  subject { @boundary_reader }

  it { should respond_to :boundaries }
  its(:records_in_file) { should == 591393 }
  its(:current_zip_level_records) { should == 630 }

  it 'outputs all the codes' do
    @boundary_reader.boundaries.each do |boundary|
      unless boundary.fips_county_code == ""
        puts "Zip Code: #{boundary.zip_code_low}-#{boundary.zip_code_high}"
        puts "FIPS State Code: #{boundary.fips_state_code}"
        puts "FIPS State Indicator: #{boundary.fips_state_indicator}"
        puts "FIPS County Code: #{boundary.fips_county_code}"
        puts "FIPS Place Code: #{boundary.fips_place_code}"
        puts "FIPS Place Class Code: #{boundary.fips_place_class_code}"
        puts ""
      end
    end
    puts "----"
    @boundary_reader.boundaries.each do |boundary|
      if boundary.fips_county_code == ""
        puts "Zip Code: #{boundary.zip_code_low}-#{boundary.zip_code_high}"
        puts "FIPS State Code: #{boundary.fips_state_code}"
        puts "FIPS State Indicator: #{boundary.fips_state_indicator}"
        puts "FIPS County Code: #{boundary.fips_county_code}"
        puts "FIPS Place Code: #{boundary.fips_place_code}"
        puts "FIPS Place Class Code: #{boundary.fips_place_class_code}"
        puts ""
      end
    end
  end


  describe 'boundaries' do
    subject { @boundary_reader.boundaries }
    it { should have_at_least(1).items }
    it { should have(630).items }

    it 'has valid boundary objects' do
      subject.each do |boundary|
        boundary.record_type.should == 'Z'
        boundary.beginning_effective_date.should <= Date.today
        boundary.ending_effective_date.should >= Date.today
      end
    end

    it 'has no zip code ranges' do
      subject.each do |boundary|
        boundary.zip_code_low.should == boundary.zip_code_high
      end
    end

    it 'has no zip+4 codes' do
      subject.each do |boundary|
        boundary.zip_extension_low.should == ""
        boundary.zip_extension_high.should == ""
      end
    end

    it 'has no composite SER code' do
      subject.each do |boundary|
        boundary.composite_ser_code.should == ""
      end
    end

  end
end



