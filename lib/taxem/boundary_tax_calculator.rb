module Taxem
  class BoundaryTaxCalculator

    def initialize(boundary, rates)
      @state_code = boundary.fips_state_code
      @state_indicator = boundary.fips_state_indicator
      @county_code = boundary.fips_county_code
      @place_code = boundary.fips_place_code

      @state_tax = 0
      @state_tax = rates.by_state[@state_indicator] unless @state_indicator == "0"

      @county_tax = 0
      @county_tax = rates.by_county[@county_code] unless @county_code == ""

      @place_tax = 0
      @place_tax = rate.by_place[@place_code] unless @place_code == ""


    end

  end
end

