module Taxem
  class TaxCalculator
    class InvalidStateIndicator < RuntimeError
    end

    def initialize(tax_rates)
      @tax_rates = tax_rates
    end

    def rate(taxable_boundary)
      unless taxable_boundary.fips_state_code == taxable_boundary.fips_state_indicator ||
          taxable_boundary.fips_state_indicator == "00" ||
          taxable_boundary.fips_state_indicator == ""
        raise InvalidStateIndicator, "Expected state indicator '#{taxable_boundary.fips_state_indicator}' to equal state code '#{taxable_boundary.fips_state_code}'"
      end

      tax_rate = 0
      unless taxable_boundary.fips_state_indicator.nil? ||
          taxable_boundary.fips_state_indicator == "" ||
          taxable_boundary.fips_state_indicator == "00"
        tax_rate += @tax_rates.for_state(taxable_boundary.fips_state_indicator)
      end

      unless taxable_boundary.fips_county_code.nil? || taxable_boundary.fips_county_code == ""
        tax_rate += @tax_rates.for_county(taxable_boundary.fips_county_code)
      end

      unless taxable_boundary.fips_place_code.nil? || taxable_boundary.fips_place_code == ""
        tax_rate += @tax_rates.for_place(taxable_boundary.fips_place_code)
      end

      tax_rate
    end

  end
end
