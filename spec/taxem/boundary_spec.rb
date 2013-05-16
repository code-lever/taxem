require 'spec_helper'

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

  readers.each do |method|
    it { should respond_to method }
  end

  (0..34).each do |item|
    its(readers[item]) { should == row[item] }
  end

  describe '::parse_line' do

    context "Line does not begin with 'Z'" do
      let(:line) { '4,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line(line) }
      it { should be_nil }
    end

    context "Line does begin with 'Z'" do
      let(:line) { 'Z,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line(line) }
      it { should be_a Taxem::Boundary }
      its(:record_type) { should == 'Z' }
    end

    context "Today is between effective dates" do
      let(:line) { 'Z,20070701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line(line) }
      it { should be_a Taxem::Boundary }
      its(:beginning_effective_date) { should == Date.new(2007, 07, 01) }
      its(:ending_effective_date) { should == Date.new(2999, 12, 31) }
    end

    context "Today is before the beginning effective date" do
      let(:line) { 'Z,20150701,29991231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line(line) }
      it { should be_nil }
    end

    context "Today is after the ending effective date" do
      let(:line) { 'Z,20070701,20081231,,,,,,,,,,,,,,,68420,,68420,,,31,31,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,' }
      subject { Taxem::Boundary.parse_line(line) }
      it { should be_nil }
    end

  end

end
