require 'spec_helper'

describe Taxem::Magento do
  let(:state) { 'NE' }
  let(:zip) { '12345' }
  let(:rate) { '0.085' }
  let(:expected_rate) { '8.5' }
  let(:data) do
    ri = Taxem::RateItem.new
    ri.state = state
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

  subject { Taxem::Magento.new(data) }
  let(:expected_string) do
    %Q("US-#{state}-#{zip}","US","#{state}","#{zip}","#{expected_rate}","","","","")
  end
  its(:code) { should == "US-#{state}-#{zip}" }
  its(:country) { should == 'US' }
  its(:state) { should == state }
  its(:zip_code) { should == zip }
  its(:rate) { should == expected_rate }
  its(:zip_is_range) { should == '' }
  its(:range_from) { should == '' }
  its(:range_to) { should == '' }
  its(:default) { should == '' }
  its(:to_s) { should == expected_string }

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

  context 'A state wide rate' do
    subject do
      data.zip = '*'
      data.place = nil
      data.county = nil
      Taxem::Magento.new(data)
    end
    let(:expected_string) do
      %Q("US-#{state}-*","US","#{state}","*","#{expected_rate}","","","","")
    end
    its(:code) { should == "US-#{state}-*" }
    its(:zip_code) { should == '*' }
    its(:to_s) {should == expected_string}
  end


end

