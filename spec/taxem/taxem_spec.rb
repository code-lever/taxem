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
    context 'unknown zip' do
      it 'raises' do
        expect {taxem.local_rate(11111)}.to raise_error Taxem::BoundaryNotFoundError
      end
    end
  end

  describe '#boundaries_by_zip_report' do
    it "prints" do
      taxem.boundaries_by_zip_report.each { |line| puts line }
    end
  end

  describe 'Check for some key Nebraska regions' do

    locals = {
        'Ainsworth' => {69210 => 0.015},
        'Arlington' => {68002 => 0.015},
        'Ashland' => {68003 => 0.015},
        'Albion' => {68620 => 0.015},
        'Alma' => {68920 => 0.02},
        'Arapahoe' => {68922 => 0.01},
        'Arcadia' => {68815 => 0.01},
        'Arlington' => { 68002 => 0.015},
        'Arnold' => { 69120 => 0.01},
        'Ashland' => { 68003 => 0.015},
        'Atkinson' => { 68713 => 0.01},
        'Auburn' => { 68305 => 0.01},
        'Bancroft' => {68004  => 0.01 },
        'Bassett'  => {68714 => 0.01 },
        'Bayard'  => {69334 => 0.01 },
        'Beatrice'  => {68310 => 0.015 },
        'Beaver City' => {68926 => 0.01},
    }

    locals.each do |local, zips|
      describe "#{local}" do
        zips.each do |zip, rate|
          context "with #{zip}" do
            subject { taxem.local_rate(zip) }
            its(:rate) { should == rate }
          end
        end
      end
    end
  end

end