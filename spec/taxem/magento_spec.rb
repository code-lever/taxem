require 'spec_helper'

describe Taxem::Magento do
  let(:state) { 'NE' }
  let(:county) { 'Douglas' }
  let(:place) { 'Omaha' }
  let(:zip) { '12345' }
  let(:rate) { '8.5' }
  let(:data) do
    ri = Taxem::RateItem.new
    ri.state = state
    ri.county = county
    ri.place = place
    ri.zip = zip
    ri.rate = rate
    ri
  end

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

  context 'State, county, and place' do
    subject { Taxem::Magento.new(data) }
    let(:expected_string) do
      %Q("US-#{state}-#{county}-#{place}-#{zip}","US","#{state}","#{zip}","#{rate}","","","","")
    end
    its(:code) { should == "US-#{state}-#{county}-#{place}-#{zip}" }
    its(:country) { should == 'US' }
    its(:state) { should == state }
    its(:zip_code) { should == zip }
    its(:rate) { should == rate }
    its(:zip_is_range) { should == '' }
    its(:range_from) { should == '' }
    its(:range_to) { should == '' }
    its(:default) { should == '' }
    its(:to_s) { should == expected_string }
  end

  context 'State and county only' do
    subject do
      data.place = nil
      Taxem::Magento.new(data)
    end
    let(:expected_string) do
      %Q("US-#{state}-#{county}-#{zip}","US","#{state}","#{zip}","#{rate}","","","","")
    end
    its(:code) { should == "US-#{state}-#{county}-#{zip}" }
    its(:country) { should == 'US' }
    its(:state) { should == state }
    its(:zip_code) { should == zip }
    its(:rate) { should == rate }
    its(:zip_is_range) { should == '' }
    its(:range_from) { should == '' }
    its(:range_to) { should == '' }
    its(:default) { should == '' }
    its(:to_s) { should == expected_string }
  end

  context 'State only' do
    subject do
      data.place = nil
      data.county = nil
      Taxem::Magento.new(data)
    end
    let(:expected_string) do
      %Q("US-#{state}-#{zip}","US","#{state}","#{zip}","#{rate}","","","","")
    end
    its(:code) { should == "US-#{state}-#{zip}" }
    its(:country) { should == 'US' }
    its(:state) { should == state }
    its(:zip_code) { should == zip }
    its(:rate) { should == rate }
    its(:zip_is_range) { should == '' }
    its(:range_from) { should == '' }
    its(:range_to) { should == '' }
    its(:default) { should == '' }
    its(:to_s) { should == expected_string }
  end

  context 'No zip provided' do
    it 'raises' do
      data.zip = nil
      expect { Taxem::Magento.new(data) }.to raise_error Taxem::Magento::NoZipError
    end
  end

  context 'No state provided' do
    it 'raises' do
      data.state = nil
      expect { Taxem::Magento.new(data) }.to raise_error Taxem::Magento::NoStateError
    end
  end

  context 'No rate provided' do
    it 'raises' do
      data.rate = nil
      expect { Taxem::Magento.new(data) }.to raise_error Taxem::Magento::NoRateError
    end
  end

end

