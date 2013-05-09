require 'spec_helper'

describe Taxem::RateReader do

  before(:all) do
    path_to_csv = rate_data
    @rate_reader = Taxem::RateReader.new(path_to_csv)
  end

  subject { @rate_reader }
  let(:jurisdiction_types) do
    ['45', # State
     '00', # County
     '01'  # City
    ]
  end

  let(:nebraska) {'31'}

  it { should respond_to :rates }
  its(:records_in_file) { should == 246 }
  its(:current_records) { should == 210 }

  describe 'rates' do
    subject { @rate_reader.rates }
    it { should have_at_least(1).items }
    it { should have(210).items }

    it 'has valid rate objects' do
      subject.each do |rate|
        rate.state.should == nebraska
        rate.effective_begin_date.should <= Date.today
        rate.effective_end_date.should >= Date.today
        jurisdiction_types.should include(rate.jurisdiction_type)
      end
    end

  end
end



