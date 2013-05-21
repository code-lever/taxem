require 'spec_helper'
require 'taxem/rate_shared_example'

describe Taxem::Rate do
  before(:all) do
    @row = (0..8).map { |i| i }
    @row[7] = Date.new(2001, 2, 3)
    @row[8] = Date.new(2002, 2, 3)
  end

  let(:row) { @row }
  subject { Taxem::Rate.new(row) }

  its(:general_tax_rate_intrastate) { should be_a Float }
  its(:general_tax_rate_interstate) { should be_a Float }
  its(:food_drug_tax_rate_intrastate) { should be_a Float }
  its(:food_drug_tax_rate_interstate) { should be_a Float }
  its(:to_s) { should == "0, 1, 2, 3.0, 4.0, 5.0, 6.0, 2001-02-03, 2002-02-03" }

  it_behaves_like "a rate for TaxRates"

  readers = [:state,
             :jurisdiction_type,
             :jurisdiction_fips_code,
             :general_tax_rate_intrastate,
             :general_tax_rate_interstate,
             :food_drug_tax_rate_intrastate,
             :food_drug_tax_rate_interstate,
             :effective_begin_date,
             :effective_end_date]

  readers.each do |method|
    it { should respond_to method }
  end

  (0..7).each do |item|
    its(readers[item]) { should == row[item] }
  end


  describe "#same_except_rates" do
    it "is true if attr's except for dates are equal" do
      rate1 = Taxem::Rate.new(row)
      rate2 = Taxem::Rate.new(row)
      rate1.same_except_dates?(rate2.clone).should == true
    end

    it "is false if anything other than the dates if different" do
      rate1 = Taxem::Rate.new(row)
      (0..6).each do |i|
        my_row = row.clone
        my_row[i] = 99
        rate2 = Taxem::Rate.new(my_row)
        rate1.same_except_dates?(rate2).should == false
      end
    end

    it "is true if the dates are different" do
      rate1 = Taxem::Rate.new(row)
      (7..8).each do |i|
        my_row = row.clone
        my_row[i] = Date.new(2011, 11, 11)
        rate2 = Taxem::Rate.new(my_row)
        rate1.same_except_dates?(rate2).should == true
      end
    end
  end

  describe '::parse_line' do
    context "Today is between effective dates" do
      let(:line) { '31,45,31,0.0550,0.0550,0.0550,0.0550,20061001,29991231' }
      subject { Taxem::Rate.parse_line(line) }
      it { should be_a Taxem::Rate }
      its(:state) { should == '31' }
      its(:effective_begin_date) { should == Date.new(2006, 10, 01) }
      its(:effective_end_date) { should == Date.new(2999, 12, 31) }
    end

    context "Today is before effective dates" do
      let(:line) { '31,45,31,0.0550,0.0550,0.0550,0.0550,20151001,29991231' }
      subject { Taxem::Rate.parse_line(line) }
      it { should be_nil }
    end

    context "Today is after effective dates" do
      let(:line) { '31,01,21415,0.0150,0.0150,0.0150,0.0150,20061001,20070331' }
      subject { Taxem::Rate.parse_line(line) }
      it { should be_nil }
    end

  end

end
