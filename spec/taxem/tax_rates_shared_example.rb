require "spec_helper"

shared_examples "a TaxRates object" do
  it { should respond_to :for_code }

  it 'should return 0 if the code is "00"' do
    subject.for_code("00").should == 0
  end

  it 'should return 0 if the code is ""' do
    subject.for_code("").should == 0
  end

  it 'should return 0 if the code is nil' do
    subject.for_code(nil).should == 0
  end

  it 'should throw if the rate cannot be found' do
    expect {subject.for_code("unknown")}.to raise_error Taxem::RateNotFoundError
  end

end
