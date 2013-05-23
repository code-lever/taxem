require 'spec_helper'

describe Taxem::FipsCounty do
  # The format is specified here.
  # http://www.census.gov/geo/www/ansi/download.html
  before(:all) do
    @row = (0..4).map { |i| "#{i}" }
  end
  let(:row) { @row }

  subject { Taxem::FipsCounty.new(row) }
  attributes = [:state,
                :state_ansi,
                :county_ansi,
                :county_name,
                :ansi_class]

  it { should respond_to :row }
  its(:row) { should == row }

  its(:to_s) { should == "0, 1, 2, 3, 4" }

  attributes.each do |method|
    it { should respond_to method }
  end

  (0..4).each do |i|
    its(attributes[i]) { should == row[i] }
  end

  it { should respond_to :fips_county_code }

  # the fips_county_code should be the state and county codes
  # concatenated together
  its(:fips_county_code) { should == "12" }

  its(:county_name_no_county) {should == "3"}

  describe "::parse_line" do
    let(:line) { "AL,01,001,Autauga County,H1" }
    subject { Taxem::FipsCounty.parse_line(line) }
    its(:state) { should == "AL" }
    its(:county_ansi) { should == "001" }
    its(:county_name) { should == 'Autauga County' }
    its(:fips_county_code) { should == '01001' }
    its(:county_name_no_county) {should == 'Autauga'}
  end

end


