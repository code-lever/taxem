require 'spec_helper'

describe Taxem::Rate do
  let(:row) { (0..7).map { |i| i } }
  before(:all) do
    @row = (0..8).map { |i| i }
    @row[7] = Date.new(2001, 2, 3)
    @row[8] = Date.new(2002, 2, 3)
  end

  let(:row) { @row }
  subject { Taxem::Rate.new(row) }
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