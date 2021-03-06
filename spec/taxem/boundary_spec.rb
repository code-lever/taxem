require 'spec_helper'
require 'taxem/taxable_boundary_shared_example'
require 'taxem/boundary_shared_example'

describe Taxem::Boundary do
  before(:all) do
    @row = (0..34).map { |i| i }
    @row[1] = Date.new(2001, 2, 3)
    @row[2] = Date.new(2002, 3, 4)
  end

  let(:row) { @row }
  subject { Taxem::Boundary.new(row) }
  readers = [:record_type,
             :beginning_effective_date,
             :ending_effective_date,
             :low_address_range,
             :high_address_range,
             :odd_even_range,
             :street_pre_directional_abbr,
             :street_name,
             :street_suffix,
             :street_post_directional,
             :address_secondary_abbr,
             :address_secondary_low,
             :address_secondary_high,
             :address_secondary_odd_even,
             :city_name,
             :zip_code,
             :plus4,
             :zip_code_low,
             :zip_extension_low,
             :zip_code_high,
             :zip_extension_high,
             :composite_ser_code,
             :fips_state_code,
             :fips_state_indicator,
             :fips_county_code,
             :fips_place_code,
             :fips_place_class_code,
             :longitude_data,
             :latitude_data,
             :special_tax_district_code_source_1,
             :special_tax_district_code_1,
             :type_of_taxing_authority_code_1,
             :special_tax_district_code_source_20,
             :special_tax_district_code_20,
             :type_of_taxing_authority_code_20]

  it { should respond_to :row }
  its(:row) { should == row }

  its(:to_s) { should == "0, 2001-02-03, 2002-03-04, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34" }

  it_behaves_like "a TaxableBoundary object"
  it_behaves_like "a boundary for ZipBoundaries"
  it_behaves_like 'a boundary for FipsCountyReader'
  it_behaves_like 'a boundary for FipsPlaceReader'

  readers.each do |method|
    it { should respond_to method }
  end

  (0..34).each do |item|
    its(readers[item]) { should == row[item] }
  end

  its(:state_county_code) { should == "#{subject.fips_state_code}#{subject.fips_county_code}" }
  its(:state_place_code) { should == "#{subject.fips_state_code}#{subject.fips_place_code}" }
  its(:county_place_code) { should == "#{subject.fips_county_code}#{subject.fips_place_code}" }

  describe '#has_local_tax?' do
    context 'has a county and place code' do
      let(:line) { '4,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,1,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      its(:fips_county_code) { should == '1' }
      its(:fips_place_code) { should == '1' }
      its(:has_local_tax?) { should be_true }
    end
    context 'has a county code only' do
      let(:line) { '4,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      its(:fips_county_code) { should == '1' }
      its(:fips_place_code) { should be_empty }
      its(:has_local_tax?) { should be_true }
    end
    context 'has a place code only' do
      let(:line) { '4,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      its(:fips_county_code) { should be_empty }
      its(:fips_place_code) { should == '1' }
      its(:has_local_tax?) { should be_true }
    end
    context 'has a neither a county or a place code only' do
      let(:line) { '4,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      its(:fips_county_code) { should be_empty }
      its(:fips_place_code) { should be_empty }
      its(:has_local_tax?) { should be_false }
    end
  end

  describe '::parse_line_zip' do

    context "Line does not begin with 'Z'" do
      let(:line) { '4,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip(line) }
      it { should be_nil }
    end

    context "Line does begin with 'Z'" do
      let(:line) { 'Z,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip(line) }
      it { should be_a Taxem::Boundary }
      its(:record_type) { should == 'Z' }
    end

    context "Today is between effective dates" do
      let(:line) { 'Z,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip(line) }
      it { should be_a Taxem::Boundary }
      its(:beginning_effective_date) { should == Date.new(2007, 07, 01) }
      its(:ending_effective_date) { should == Date.new(2999, 12, 31) }
    end

    context "Today is before the beginning effective date" do
      let(:line) { 'Z,20150701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip(line) }
      it { should be_nil }
    end

    context "Today is after the ending effective date" do
      let(:line) { 'Z,20070701,20081231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip(line) }
      it { should be_nil }
    end

  end

  describe '::parse_line_zip4' do

    context "Line does not begin with '4'" do
      let(:line) { 'Z,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      it { should be_nil }
    end

    context "Line does begin with 'Z'" do
      let(:line) { '4,20080401,29991231,,,,,,,,,,,,,,,68128,3070,68128,3080,,31,31,,26385,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      it { should be_a Taxem::Boundary }
      its(:record_type) { should == '4' }
    end

    context "Today is between effective dates" do
      let(:line) { '4,20080401,29991231,,,,,,,,,,,,,,,68128,3070,68128,3080,,31,31,,26385,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      it { should be_a Taxem::Boundary }
      its(:beginning_effective_date) { should == Date.new(2008, 04, 01) }
      its(:ending_effective_date) { should == Date.new(2999, 12, 31) }
    end

    context "Today is before the beginning effective date" do
      let(:line) { '4,20151001,20991231,,,,,,,,,,,,,,,68128,3065,68128,3065,,31,31,,38295,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      it { should be_nil }
    end

    context "Today is after the ending effective date" do
      let(:line) { '4,20061001,20070630,,,,,,,,,,,,,,,68128,3065,68128,3065,,31,31,,38295,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line_zip4(line) }
      it { should be_nil }
    end
  end


end
