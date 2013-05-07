require 'spec_helper'

describe Taxem::Magento do
  let(:zip_range_from) { '11111' }
  let(:zip_range_to) { '22222' }
  let(:rate) { '8.5' }
  let(:data) { {zip_range_from: zip_range_from,
                zip_range_to: zip_range_to,
                rate: rate} }
  subject { Taxem::Magento.new(data) }

  it { should respond_to :code }
  it { should respond_to :country }
  it { should respond_to :state }
  it { should respond_to :zip_code }
  it { should respond_to :rate }
  it { should respond_to :zip_is_range }
  it { should respond_to :range_from }
  it { should respond_to :range_to }
  it { should respond_to :default }

  describe '::header' do
    subject { Taxem::Magento }
    it { should respond_to :header }
    its(:header) do
      should == ["Code", "Country", "State", "Zip/Post Code", "Rate", "Zip/Post is Range", "Range From", "Range To", "default"]
    end
    its(:header_to_s) do
      should == %q("Code","Country","State","Zip/Post Code","Rate","Zip/Post is Range","Range From","Range To","default")
    end

  end

  let(:expected_string) do
    %Q("US-NE-#{zip_range_from}-#{zip_range_to}-Rate 1","US","NE","#{zip_range_from}-#{zip_range_to}","#{rate}","1","#{zip_range_from}","#{zip_range_to}","")
  end
  its(:code) { should == "US-NE-#{zip_range_from}-#{zip_range_to}-Rate 1" }
  its(:country) { should == 'US' }
  its(:state) { should == 'NE' }
  its(:zip_code) { should == "#{zip_range_from}-#{zip_range_to}" }
  its(:rate) { should == rate }
  its(:zip_is_range) { should == '1' }
  its(:range_from) { should == zip_range_from }
  its(:range_to) { should == zip_range_to }
  its(:default) { should == "" }
  its(:to_s) { should == expected_string }

end


