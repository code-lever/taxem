require "spec_helper"
require "taxem/tax_rates_shared_example"

describe Taxem::TaxRates do
  it_behaves_like "a TaxRates object"

  let(:rate1) do
    rate = double("Rate")
    rate.stub(:jurisdiction_fips_code).and_return("1")
    rate.stub(:general_tax_rate_intrastate).and_return(1.0)
    rate.stub(:effective_begin_date).and_return(Date.new(2006, 1, 1))
    rate.stub(:effective_end_date).and_return(Date.new(2999, 12, 31))
    rate.stub(:same_except_dates?).and_return(true)
    rate.stub(:state_rate?).and_return(false)
    rate
  end

  describe "Rate1" do
    subject { rate1 }
    it_behaves_like 'a rate for TaxRates'
  end

  let(:rate_not_same_except_date) do
    rate = double("Rate")
    rate.stub(:jurisdiction_fips_code).and_return("333333")
    rate.stub(:general_tax_rate_intrastate).and_return(1.0)
    rate.stub(:effective_begin_date).and_return(Date.new(2006, 1, 1))
    rate.stub(:effective_end_date).and_return(Date.new(2099, 12, 31))
    rate.stub(:same_except_dates?).and_return(false)
    rate.stub(:state_rate?).and_return(false)
    rate
  end

  describe "rate_same_except_date" do
    subject { rate_not_same_except_date }
    it_behaves_like 'a rate for TaxRates'
  end

  let(:rate2) do
    rate = double("Rate")
    rate.stub(:jurisdiction_fips_code).and_return("2")
    rate.stub(:general_tax_rate_intrastate).and_return(2.0)
    rate.stub(:effective_begin_date).and_return(Date.new(2006, 1, 1))
    rate.stub(:effective_end_date).and_return(Date.new(2999, 12, 31))
    rate.stub(:same_except_dates?).and_return(true)
    rate.stub(:state_rate?).and_return(false)
    rate
  end

  describe "Rate2" do
    subject { rate2 }
    it_behaves_like 'a rate for TaxRates'
  end

  let(:state_rate) do
    rate = double("Rate")
    rate.stub(:jurisdiction_fips_code).and_return("2")
    rate.stub(:general_tax_rate_intrastate).and_return(2.0)
    rate.stub(:effective_begin_date).and_return(Date.new(2006, 1, 1))
    rate.stub(:effective_end_date).and_return(Date.new(2999, 12, 31))
    rate.stub(:same_except_dates?).and_return(true)
    rate.stub(:state_rate?).and_return(true)
    rate
  end

  describe "state_rate" do
    subject { state_rate }
    it_behaves_like 'a rate for TaxRates'
  end

  let(:rate_not_effective) do
    rate = double("Rate")
    rate.stub(:jurisdiction_fips_code).and_return("2")
    rate.stub(:general_tax_rate_intrastate).and_return(2.0)
    rate.stub(:effective_begin_date).and_return(Date.new(2006, 1, 1))
    rate.stub(:effective_end_date).and_return(Date.new(2007, 12, 31))
    rate.stub(:same_except_dates?).and_return(true)
    rate
  end

  describe "rate not effective" do
    subject { rate2 }
    it_behaves_like 'a rate for TaxRates'
  end

  describe "rate not effective" do
    subject { rate2 }
    it_behaves_like 'a rate for TaxRates'
  end

  its(:date) { should == Date.today }

  it 'accepts a date in the initializer' do
    Taxem::TaxRates.new(Date.new(2011, 11, 11)).date.should == Date.new(2011, 11, 11)
  end

  describe "#for_code" do
    it "raises an error if passed an unknown code" do
      expect { subject.for_code('blarhaha') }.to raise_error Taxem::RateNotFoundError
    end
  end

  describe "#add_rate" do
    it "doesn't raise an error if rates are same_except_date" do
      subject.add_rate(rate1)
      subject.add_rate(rate1)
      rate1.same_except_dates?(rate1).should be_true
    end

    it "raise error if a rate with the same code is added and not same_except_date" do
      subject.add_rate(rate_not_same_except_date)
      expect { subject.add_rate(rate_not_same_except_date) }.to raise_error Taxem::DuplicateRateError
    end

    context "rate1 added" do
      subject { Taxem::TaxRates.new.add_rate(rate1) }
      it "finds rate1" do
        subject.for_code(rate1.jurisdiction_fips_code).should == 1.0
      end
      it "doesn't find rate2 and raises" do

        expect { subject.for_code(rate2.jurisdiction_fips_code) }.to raise_error Taxem::RateNotFoundError
      end
      it "doesn't find garbage" do
        expect { subject.for_code('garbage') }.to raise_error Taxem::RateNotFoundError
      end
    end
    context "rate2 added" do
      subject { Taxem::TaxRates.new.add_rate(rate2) }
      it "doesn't find rate1 and returns 0" do
        expect { subject.for_code(rate1.jurisdiction_fips_code) }.to raise_error Taxem::RateNotFoundError
      end
      it "finds rate2" do
        subject.for_code(rate2.jurisdiction_fips_code).should == 2.0
      end
      it "doesn't find garbage" do
        expect { subject.for_code('garbage') }.to raise_error Taxem::RateNotFoundError

      end
    end
    context "both rates added" do
      subject { Taxem::TaxRates.new.add_rate(rate1).add_rate(rate2) }
      it "finds rate1" do
        subject.for_code(rate1.jurisdiction_fips_code).should == 1.0
      end
      it "finds rate2" do
        subject.for_code(rate2.jurisdiction_fips_code).should == 2.0
      end
      it "doesn't find garbage" do
        expect { subject.for_code('garbage') }.to raise_error Taxem::RateNotFoundError
      end
    end
    context "rate not effective added" do
      subject { Taxem::TaxRates.new.add_rate(rate_not_effective) }
      it "doesn't find rate_not_effective" do
        expect { subject.for_code(rate_not_effective.jurisdiction_fips_code) }.to raise_error Taxem::RateNotFoundError
      end
    end
  end
  describe "#add_rates" do
    context "rate1 and 2 in an array" do
      subject { Taxem::TaxRates.new.add_rates([rate1, rate2]) }
      it "finds rate1" do
        subject.for_code(rate1.jurisdiction_fips_code).should == 1.0
      end
      it "finds rate2" do
        subject.for_code(rate2.jurisdiction_fips_code).should == 2.0
      end
      it "doesn't find garbage" do
        expect { subject.for_code('garbage') }.to raise_error Taxem::RateNotFoundError
      end
    end
  end

  describe '#state_rate' do
    context 'rate 1 and 2 and state rate in an array' do
      subject { Taxem::TaxRates.new.add_rates([rate1, rate2, state_rate]) }
      its(:state_rate) { should == state_rate }
    end
    context 'rate 1 and 2 and no state rate' do
      subject { Taxem::TaxRates.new.add_rates([rate1, rate2]) }
      it "doesn't find state rate" do
        expect { subject.state_rate }.to raise_error Taxem::StateRateNotFoundError
      end
    end
  end

end

