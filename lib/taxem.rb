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
      boundary_reader = BoundaryReaderZipFour.new(path_to_boundaries)

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

    # the state rate is the rate where the state code is equal to the jurisdiction fips code
    #
    def state_rate
      rate = @tax_rates.state_rate
      rate_item = RateItem.new
      rate_item.zip = '*'
      rate_item.state = 'NE'
      rate_item.rate = rate.general_tax_rate_intrastate
      rate_item
    end

    def rate(zip_code)
      max_boundary = max_tax_rate_boundary(zip_code)
      rate_item = RateItem.new
      rate_item.zip = zip_code
      rate_item.state = 'NE'
      rate_item.county = @fips_county_reader.county_name_for_boundary(max_boundary) unless @fips_county_reader.nil?
      rate_item.place = @fips_place_reader.place_name_for_boundary(max_boundary) unless @fips_place_reader.nil?
      rate_item.rate = @tax_calculator.rate(max_boundary)
      rate_item
    end

    def boundaries_by_zip_report
      zips = zip_codes
      lines = []
      zips.each do |zip_code|
        lines << "Zip Code: #{zip_code}"

        # Get the unique counties and places
        the_boundaries = boundary(zip_code)
        unique_locations = the_boundaries.uniq { |b| "#{b.fips_county_code} #{b.fips_place_code}" }
        unique_locations.each do |b|
          names = []
          names << "Local Rate: #{@tax_calculator.local_rate(b)}"
          unless @fips_county_reader.nil?
            county_name = @fips_county_reader.county_name_for_boundary(b)
            names << "County: #{county_name}" unless county_name.nil?
          end

          unless @fips_place_reader.nil?
            place_name = @fips_place_reader.place_name_for_boundary(b)
            names << "Place: #{place_name}" unless place_name.nil?
          end

          lines << " + #{names.join(' ')}"
        end
      end
      lines
    end

    # Returns nil if the boundary's tax is only calculated
    # using the state rate.
    # If the state rate is the only tax rate that applies,
    # then there is NO local rate.
    #
    def local_rate(zip_code)
      max_boundary = max_tax_rate_boundary(zip_code)
      rate_item = nil
      unless max_boundary.fips_county_code == "" && max_boundary.fips_place_code == ""
        rate_item = RateItem.new
        rate_item.zip = zip_code
        rate_item.state = 'NE'
        rate_item.county = @fips_county_reader.county_name_for_boundary(max_boundary) unless @fips_county_reader.nil?
        rate_item.place = @fips_place_reader.place_name_for_boundary(max_boundary) unless @fips_place_reader.nil?
        rate_item.rate = @tax_calculator.local_rate(max_boundary)
      end
      rate_item
    end

    # Find the boundary with the largest tax rate in the zip code.
    # We will use this as the effective tax rate for the zip.
    #
    def max_tax_rate_boundary(zip_code)
      the_boundaries = boundary(zip_code)
      max_boundary = the_boundaries.max_by { |boundary| @tax_calculator.rate(boundary) }
      max_boundary
    end

  end
end

