require 'spec_helper'

shared_examples 'a boundary for ZipBoundaries' do
  it { should respond_to :zip_code_low }
  it { should respond_to :zip_code_high }
  it { should respond_to :beginning_effective_date }
  it { should respond_to :ending_effective_date }

  its(:beginning_effective_date) { should be_a Date }
  its(:ending_effective_date) { should be_a Date }
end

shared_examples 'a boundary for FipsCountyReader' do
  it { should respond_to :state_county_code }
end


