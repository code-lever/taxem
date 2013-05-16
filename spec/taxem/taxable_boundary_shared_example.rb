require "spec_helper"

shared_examples "a TaxableBoundary object" do
  it {should respond_to :fips_state_code}
  it {should respond_to :fips_state_indicator}
  it {should respond_to :fips_county_code}
  it {should respond_to :fips_place_code}
end
