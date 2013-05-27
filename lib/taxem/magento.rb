module Taxem
  class Magento
    class NoZipError < RuntimeError
    end

    class NoStateError < RuntimeError
    end

    class NoRateError < RuntimeError
    end

    attr_reader :code,
                :country,
                :state,
                :zip_code,
                :rate,
                :zip_is_range,
                :range_from,
                :range_to,
                :default

    def self.header
      ["Code", "Country", "State", "Zip/Post Code", "Rate", "Zip/Post is Range", "Range From", "Range To", "default"]
    end

    def self.header_to_s
      %Q("#{header.join('","')}")
    end

    def initialize(data)
      state = data[:state]
      raise NoStateError if state.nil?

      county = data[:county]

      place = data[:place]

      zip = data[:zip]
      raise NoZipError if zip.nil?

      rate = data[:rate]
      raise NoRateError if rate.nil?

      code_array = ['US']
      code_array << state unless state.nil?
      code_array << county unless county.nil?
      code_array << place unless place.nil?
      code_array << zip unless zip.nil?

      @code = code_array.join('-')
      @country = 'US'
      @state = state
      @zip_code = "#{zip}"
      @rate = "#{rate}"
      @zip_is_range = ''
      @range_from = ''
      @range_to = ''
      @default = ''
    end

    def to_s
      data = [code, country, state, zip_code, rate, zip_is_range, range_from, range_to, default]
      %Q("#{data.join('","')}")
    end

  end
end
