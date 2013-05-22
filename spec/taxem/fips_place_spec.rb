require 'spec_helper'

describe Taxem::FipsPlace do
  # The format is specified here.
  # http://www.census.gov/geo/www/codes/place/download.html
  before(:all) do
    @row = (0..6).map { |i| "#{i}" }
  end
  let(:row) { @row }

  subject { Taxem::FipsPlace.new(row) }
  attributes = [:state,
                :state_fp,
                :place_fp,
                :place_name,
                :type,
                :func_stat,
                :county]

  it { should respond_to :row }
  its(:row) { should == row }

  its(:to_s) { should == "0, 1, 2, 3, 4, 5, 6" }

  attributes.each do |method|
    it { should respond_to method }
  end

  (0..6).each do |i|
    its(attributes[i]) { should == row[i] }
  end

  it { should respond_to :fips_place_code }
  # The fips_place_code should be the state and place
  # codes concatenated together
  its(:fips_place_code) { should == "12" }

  describe "::parse_line" do
    let(:line) { 'AL|01|00100|Abanda CDP|Census Designated Place|S|Chambers County' }
    subject { Taxem::FipsPlace.parse_line(line) }
    its(:state) { should == "AL" }
    its(:county) { should == "Chambers County" }
    its(:fips_place_code) { should == "0100100" }
  end

end

