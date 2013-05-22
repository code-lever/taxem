require 'spec_helper'

describe Taxem::Taxem do
  before(:all) do
    @taxem = Taxem::Taxem.new(boundary_data, rate_data)
  end
  let(:taxem) { @taxem }
  subject { @taxem }

  it "should print a bunch of stuff" do
    taxem.zip_codes.each do |zip|
      puts "Zip: #{zip} Tax: #{taxem.rate_for_zip_code(zip)}"
    end
  end

  it "should get 5.5 for 68118" do
    subject.rate_for_zip_code(68118).should == 0.055
  end

  it "should get 5.5 for 68136" do
    subject.rate_for_zip_code(68136).should == 0.055
  end

  it "should get 5.5 for 68114" do
    # Nebraska furniture mart
    subject.rate_for_zip_code(68114).should == 0.07
  end
end
