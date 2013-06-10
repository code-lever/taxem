require "taxem/version"
require 'taxem/boundary'
require 'taxem/rate'
require 'taxem/boundary_reader_zip'
require 'taxem/boundary_reader_zip_four'
require 'taxem/rate_reader'
require 'taxem/magento'
require 'taxem/tax_calculator'
require 'taxem/tax_rates'
require 'taxem/zip_boundaries'
require 'taxem/fips_place'
require 'taxem/fips_county'
require 'taxem/fips_county_reader'
require 'taxem/fips_place_reader'
require 'taxem/magento_writer'

module Taxem

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

  # Raised when a request is made for a statewide rate, but one
  # is not found in the rates file.
  #
  class StateRateNotFoundError < RuntimeError
  end

  RateItem = Struct.new(:state, :county, :place, :zip, :rate)

  class Taxem

    class NoPathToBoundariesError < RuntimeError
    end

    class NoPathToRatesError < RuntimeError
    end

    def initialize(params)
      path_to_boundaries = params[:path_to_boundaries]
      raise NoPathToBondariesError if path_to_boundaries.nil?
      boundary_reader = BoundaryReaderZip.new(path_to_boundaries)

      path_to_rates = params[:path_to_rates]
      raise NoPathToRatesError if path_to_rates.nil?
      rate_reader = RateReader.new(path_to_rates)

      path_to_counties = params[:path_to_counties]
      @fips_county_reader = FipsCountyReader.new(path_to_counties) unless path_to_counties.nil?

      path_to_places = params[:path_to_places]
      @fips_place_reader = FipsPlaceReader.new(path_to_places) unless path_to_places.nil?

      @tax_rates = TaxRates.new.add_rates(rate_reader.rates)
      @zip_boundaries = ZipBoundaries.new.add_boundaries(boundary_reader.boundaries)
      @tax_calculator = TaxCalculator.new(@tax_rates)
    end

    def zip_codes
      @zip_boundaries.all_zips
    end

    def boundary(zip_code)
      boundary = @zip_boundaries.for_zip(zip_code)
      boundary
    end

    def state_rate
      # the state rate is the rate where the state code is equal to the jurisdiction fips code
      rate = @tax_rates.state_rate
      rate_item = RateItem.new
      rate_item.zip = '*'
      rate_item.state = 'NE'
      rate_item.rate = rate.general_tax_rate_intrastate
      rate_item
    end

    def rate(zip_code)
      the_boundary = boundary(zip_code)
      rate_item = RateItem.new
      rate_item.zip = zip_code
      rate_item.state = 'NE'
      rate_item.county = @fips_county_reader.county_name_for_boundary(the_boundary) unless @fips_county_reader.nil?
      rate_item.place = @fips_place_reader.place_name_for_boundary(the_boundary) unless @fips_place_reader.nil?
      rate_item.rate = @tax_calculator.rate(the_boundary)
      rate_item
    end
    def local_rate(zip_code)
      the_boundary = boundary(zip_code)
      rate_item = RateItem.new
      rate_item.zip = zip_code
      rate_item.state = 'NE'
      rate_item.county = @fips_county_reader.county_name_for_boundary(the_boundary) unless @fips_county_reader.nil?
      rate_item.place = @fips_place_reader.place_name_for_boundary(the_boundary) unless @fips_place_reader.nil?
      rate_item.rate = @tax_calculator.local_rate(the_boundary)
      rate_item
    end

  end
end

