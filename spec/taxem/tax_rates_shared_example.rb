require "spec_helper"

shared_examples "a TaxRates object" do
  it {should respond_to :for_state}
  it {should respond_to :for_county}
  it {should respond_to :for_place}
end
