require 'spec_helper'
require 'taxem/boundary_shared_example'

describe Taxem::FipsCountyReader do
  before (:all) do
    @fips_county_reader = Taxem::FipsCountyReader.new(county_data)
  end

  let(:boundary) do
    boundary = double('Boundary')
    boundary.stub(:state_county_code).and_return('31055')
    boundary
  end

  describe 'boundary' do
    subject {boundary}
    it_behaves_like 'a boundary for FipsCountyReader'
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
    its(:state_county_code) {should == '31055'}
    its(:short_county_name) {should == 'Douglas'}
  end

  describe '#county_for_boundary' do
    subject {@fips_county_reader}
    it "finds the county name for the boundary" do
      subject.county_for_boundary(boundary).should == 'Douglas'
    end
  end

end

