require 'spec_helper'

describe Taxem::FipsCountyReader do
  before (:all) do
    @fips_county_reader = Taxem::FipsCountyReader.new(county_data)
  end

  subject { @fips_county_reader }

  it { should respond_to :counties }
  its(:counties) { should be_a Hash }

  its(:records_in_file) { should == subject.counties.size }
  its(:path_to_csv) { should == county_data }

  describe 'counties' do
    subject { @fips_county_reader.counties }
    it { should have_at_least(1).item }
    it { should have(3236).items }
  end

  describe 'douglas county' do
    subject { @fips_county_reader.counties['31055'] }
    its(:state) { should == 'NE' }
    its(:state_ansi) { should == '31' }
    its(:county_ansi) { should == '055' }
    its(:county_name) { should == 'Douglas County' }
    its(:ansi_class) { should == 'H1' }
  end
end

