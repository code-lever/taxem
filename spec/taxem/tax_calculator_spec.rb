require 'spec_helper'
require 'taxem/tax_rates_shared_example'
require 'taxem/taxable_boundary_shared_example'

describe Taxem::TaxCalculator do
  before(:each) do
    @tax_rates = double("TaxRates")
    @tax_rates.stub(:for_state).and_return(1)
    @tax_rates.stub(:for_county).and_return(2)
    @tax_rates.stub(:for_place).and_return(3)
  end
  let(:tax_rates) { @tax_rates }

  describe "tax_rates" do
    subject { tax_rates }
    it_behaves_like "a TaxRates object"
  end
  subject { Taxem::TaxCalculator.new(@tax_rates) }

  context "when the boundary has a state indicator only" do
    before(:each) do
      @taxable_boundary = double("taxable_boundary")
      @taxable_boundary.stub(:fips_state_code) { "1" }
      @taxable_boundary.stub(:fips_state_indicator) { "1" }
      @taxable_boundary.stub(:fips_county_code) { "" }
      @taxable_boundary.stub(:fips_place_code) { "" }
    end
    describe "@taxable_boundary" do
      subject { @taxable_boundary }
      it_behaves_like "a TaxableBoundary object"
    end
    it "#rate" do
      subject.rate(@taxable_boundary).should == tax_rates.for_state
    end
  end

  context "when the boundary has a state indicator and a county" do
    before(:each) do
      @taxable_boundary = double("taxable_boundary")
      @taxable_boundary.stub(:fips_state_code) { "1" }
      @taxable_boundary.stub(:fips_state_indicator) { "1" }
      @taxable_boundary.stub(:fips_county_code) { "2" }
      @taxable_boundary.stub(:fips_place_code) { "" }
    end
    describe "@taxable_boundary" do
      subject { @taxable_boundary }
      it_behaves_like "a TaxableBoundary object"
    end

    it "#rate" do
      subject.rate(@taxable_boundary).should == tax_rates.for_state + tax_rates.for_county
    end
  end

  context "when the boundary has a state indicator, a county, and a place" do
    before(:each) do
      @taxable_boundary = double("taxable_boundary")
      @taxable_boundary.stub(:fips_state_code) { "1" }
      @taxable_boundary.stub(:fips_state_indicator) { "1" }
      @taxable_boundary.stub(:fips_county_code) { "2" }
      @taxable_boundary.stub(:fips_place_code) { "3" }
    end
    describe "@taxable_boundary" do
      subject { @taxable_boundary }
      it_behaves_like "a TaxableBoundary object"
    end
    it "#rate" do
      subject.rate(@taxable_boundary).should == tax_rates.for_state + tax_rates.for_county + tax_rates.for_place
    end
  end

  context "when the boundary has an state indicator of '00'" do
    before(:each) do
      @taxable_boundary = double("taxable_boundary")
      @taxable_boundary.stub(:fips_state_code) { "1" }
      @taxable_boundary.stub(:fips_state_indicator) { "00" }
      @taxable_boundary.stub(:fips_county_code) { "2" }
      @taxable_boundary.stub(:fips_place_code) { "3" }
    end
    describe "@taxable_boundary" do
      subject { @taxable_boundary }
      it_behaves_like "a TaxableBoundary object"
    end
    it "#rate" do
      subject.rate(@taxable_boundary).should == tax_rates.for_county + tax_rates.for_place
    end
  end

  context "when the boundary has an state indicator of ''" do
    before(:each) do
      @taxable_boundary = double("taxable_boundary")
      @taxable_boundary.stub(:fips_state_code) { "1" }
      @taxable_boundary.stub(:fips_state_indicator) { "" }
      @taxable_boundary.stub(:fips_county_code) { "2" }
      @taxable_boundary.stub(:fips_place_code) { "3" }
    end
    describe "@taxable_boundary" do
      subject { @taxable_boundary }
      it_behaves_like "a TaxableBoundary object"
    end
    it "#rate" do
      subject.rate(@taxable_boundary).should == tax_rates.for_county + tax_rates.for_place
    end
  end

  context "when the boundary has an state indicator that does not match the state code" do
    before(:each) do
      @taxable_boundary = double("taxable_boundary")
      @taxable_boundary.stub(:fips_state_code) { "1" }
      @taxable_boundary.stub(:fips_state_indicator) { "9" }
      @taxable_boundary.stub(:fips_county_code) { "2" }
      @taxable_boundary.stub(:fips_place_code) { "3" }
    end
    describe "@taxable_boundary" do
      subject { @taxable_boundary }
      it_behaves_like "a TaxableBoundary object"
    end
    it "#rate" do
      expect { subject.rate(@taxable_boundary) }.to raise_error Taxem::TaxCalculator::InvalidStateIndicator
    end
  end
end

