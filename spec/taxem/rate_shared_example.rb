require 'spec_helper'

shared_examples 'a rate for TaxRates' do
  it { should respond_to :jurisdiction_fips_code }
  it { should respond_to :general_tax_rate_intrastate }
  it { should respond_to :effective_begin_date }
  it { should respond_to :effective_end_date }
  it { should respond_to :same_except_dates? }

  its(:general_tax_rate_intrastate) { should be_a Float }
  its(:effective_end_date) { should be_a Date }
  its(:effective_begin_date) { should be_a Date }
end
