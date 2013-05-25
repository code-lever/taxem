require 'spec_helper'

describe Taxem::FipsPlaceReader do
  before (:all) do
    @fips_place_reader = Taxem::FipsPlaceReader.new(place_data)
  end

  subject { @fips_place_reader }

  it { should respond_to :places }
  its(:places) { should be_a Hash }

  its(:records_in_file) { should == 41415 }
  its(:path_to_csv) { should == place_data }

  describe 'places' do
    subject { @fips_place_reader.places }
    it { should have_at_least(1).item }
    it { should have(38003).items }
  end

  describe 'Omaha' do
    subject { @fips_place_reader.places['3137000'] }
    its(:state) { should == 'NE' }
    its(:state_fp) { should == '31' }
    its(:place_fp) { should == '37000' }
    its(:place_name) { should == 'Omaha city' }
    its(:type) { should == 'Incorporated Place' }
    its(:func_stat) { should == 'A' }
    its(:county) { should == 'Douglas County' }
    its(:short_place_name) { should == 'Omaha' }
  end
end

