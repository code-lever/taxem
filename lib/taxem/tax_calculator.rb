module Taxem
  class TaxCalculator


    def initialize(tax_rates)
      @tax_rates = tax_rates
    end

    def rate(taxable_boundary)
      unless taxable_boundary.fips_state_code == taxable_boundary.fips_state_indicator ||
          taxable_boundary.fips_state_indicator == "00" ||
          taxable_boundary.fips_state_indicator == ""
        raise InvalidStateIndicatorError, "Expected state indicator '#{taxable_boundary.fips_state_indicator}' to equal state code '#{taxable_boundary.fips_state_code}'"
      end

      tax_rate = 0
      tax_rate += @tax_rates.for_code(taxable_boundary.fips_state_indicator)
      tax_rate += @tax_rates.for_code(taxable_boundary.fips_county_code)
      tax_rate += @tax_rates.for_code(taxable_boundary.fips_place_code)

    end

  end
end
