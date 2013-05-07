module Taxem
  class Magento
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
      zip_range_from = data[:zip_range_from]
      zip_range_to = data[:zip_range_to]
      rate = data[:rate]

      @code = "US-NE-#{zip_range_from}-#{zip_range_to}-Rate 1"
      @country = 'US'
      @state = 'NE'
      @zip_code = "#{zip_range_from}-#{zip_range_to}"
      @rate = rate
      @zip_is_range = '1'
      @range_from = zip_range_from
      @range_to = zip_range_to
      @default = ""
    end

    def to_s
      data = [code, country, state, zip_code, rate, zip_is_range, range_from, range_to, default]
      %Q("#{data.join('","')}")
    end

  end
end
