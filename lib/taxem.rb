require "taxem/version"
require 'taxem/boundary'
require 'taxem/rate'
require 'taxem/boundary_reader'
require 'taxem/rate_reader'
require 'taxem/magento'
require 'taxem/tax_calculator'
require 'taxem/tax_rates'
require 'taxem/zip_boundaries'

module Taxem
  # Your code goes here...

  # Raised when computing the tax for a boundary
  # and there is no corresponding tax rate for either:
  # 1. The FIPS State Indicator, if present or not "00"
  # 2. The FIPS County, if present
  # 3. The FIPS Place Number, if present.
  # Note that the tax rate must be valid for the date.
  #
  class RateNotFoundError < RuntimeError
  end

  # Raised when the boundaries state indicator
  # is not equal to the FIPS state code,
  # equal to "",
  # or Nil.
  #
  class InvalidStateIndicatorError < RuntimeError
  end

  # Raised when a rate with the same code is
  # added to tax rates. There should only be one
  # effective rate for the specified time period.
  #
  class DuplicateRateError < RuntimeError
  end

  # Raised when a boundary with a duplicate 5 digit zip code
  # is added to ZipBoundaries. There should only be one
  # effective zip code for the specified time period.
  #
  class DuplicateZipCodeError < RuntimeError
  end

  class Taxem
    def initialize(path_to_boundaries, path_to_rates)
      boundary_reader = BoundaryReader.new(path_to_boundaries)
      rate_reader = RateReader.new(path_to_rates)

      @tax_rates = TaxRates.new.add_rates(rate_reader.rates)
      @zip_boundaries = ZipBoundaries.new.add_boundaries(boundary_reader.boundaries)
      @tax_calculator = TaxCalculator.new(@tax_rates)
    end

    def rate_for_zip_code(zip_code)
      boundary = @zip_boundaries.for_zip(zip_code)
      @tax_calculator.rate(boundary)
    end

    def zip_codes
      @zip_boundaries.all_zips
    end
  end
end
