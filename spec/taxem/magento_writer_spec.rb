require 'spec_helper'

describe Taxem::MagentoWriter do
  it "dumps the data" do
   paths = {
       path_to_boundaries: boundary_data,
       path_to_rates: rate_data,
       path_to_counties: county_data,
       path_to_places: place_data
   }

   writer = Taxem::MagentoWriter.new(paths)
   writer.write('./tax_rates.csv')
  end
end

