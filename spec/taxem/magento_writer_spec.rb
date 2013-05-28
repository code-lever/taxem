require 'spec_helper'

describe Taxem::MagentoWriter do
  it "dumps the data" do
   root_path = Pathname.new('/Users/gcook/code/taxem/spec/taxem/tax_data').realpath
   paths = {
       path_to_boundaries: (root_path + 'NEB2013Q2FEB25.txt').realpath,
       path_to_rates: (root_path + 'NER2013Q2FEB25.txt').realpath,
       path_to_counties: (root_path + 'national.txt').realpath,
       path_to_places: (root_path + 'PLACElist.txt').realpath
   }

   writer = Taxem::MagentoWriter.new(paths)
   writer.write('./tax_rates.csv')
  end
end

