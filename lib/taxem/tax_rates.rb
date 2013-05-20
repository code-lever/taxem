module Taxem
  class TaxRates

    # Create a class which will respond to the same method as the rate.
    # for our dummy codes; nil, "00", and ""
    DummyRate = Struct.new(:general_tax_rate_intrastate)

    attr_reader :date

    def initialize(date = Date.today)
      @date = date
      @by_code = Hash.new

      # Expected codes that should be zero
      @by_code[""] = DummyRate.new(0.0)
      @by_code[nil] = DummyRate.new(0.0)
      @by_code["00"] = DummyRate.new(0.0)
    end

    def add_rate(rate)
      if date.between?(rate.effective_begin_date, rate.effective_end_date)
        raise DuplicateRateError if @by_code.has_key? rate.jurisdiction_fips_code
        @by_code[rate.jurisdiction_fips_code] = rate
      end
      self
    end

    def add_rates(rates)
      rates.each do |rate|
        add_rate(rate)
      end
      self
    end

    # Get the tax rate as a double for the code.
    def for_code(code)
      raise RateNotFoundError unless @by_code.has_key? code
      rate = @by_code[code].general_tax_rate_intrastate
      rate
    end

  end
end
