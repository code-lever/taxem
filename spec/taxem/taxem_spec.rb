require 'spec_helper'

describe Taxem::Taxem do
  before(:all) do
    @taxem = Taxem::Taxem.new(path_to_boundaries: boundary_data,
                              path_to_rates: rate_data,
                              path_to_counties: county_data,
                              path_to_places: place_data
    )
  end
  let(:taxem) { @taxem }
  subject { @taxem }

  describe '#rate' do

    it "should have a rate for all zips" do
      taxem.zip_codes.each do |zip|
        taxem.rate(zip).rate.should > 0.0
      end
    end

    it "should get 7.0 for 68118" do
      subject.rate(68118).rate.should == 0.07
    end

    it "should get 5.5 for 68136" do
      subject.rate(68136).rate.should == 0.055
    end

    it "should get 5.5 for 68114" do
      # Nebraska furniture mart
      subject.rate(68114).rate.should == 0.07
    end
  end

  describe '#local_rate' do
    context '68114' do
      subject { taxem.local_rate(68114) }
      its(:rate) { should == 0.015 }
    end
    context '68010' do
      subject { taxem.local_rate(68010) }
      it { should be_nil }
    end

  end

  describe '#boundaries_by_zip_report' do
    it "prints" do
      taxem.boundaries_by_zip_report.each { |line| puts line }
    end
  end

end
