module Taxem
  class Boundary
    attr_reader :row,
                :record_type,
                :beginning_effective_date,
                :ending_effective_date,
                :low_address_range,
                :high_address_range,
                :odd_even_range,
                :street_pre_directional_abbr,
                :street_name,
                :street_suffix,
                :street_post_directional,
                :address_secondary_abbr,
                :address_secondary_low,
                :address_secondary_high,
                :address_secondary_odd_even,
                :city_name,
                :zip_code,
                :plus4,
                :zip_code_low,
                :zip_extension_low,
                :zip_code_high,
                :zip_extension_high,
                :composite_ser_code,
                :fips_state_code,
                :fips_state_indicator,
                :fips_county_code,
                :fips_place_code,
                :fips_place_class_code,
                :longitude_data,
                :latitude_data,
                :special_tax_district_code_source_1,
                :special_tax_district_code_1,
                :type_of_taxing_authority_code_1,
                :special_tax_district_code_source_20,
                :special_tax_district_code_20,
                :type_of_taxing_authority_code_20


    def initialize(row)
      @row = row
      @record_type = row[0]
      @beginning_effective_date = Date.parse(row[1].to_s)
      @ending_effective_date = Date.parse(row[2].to_s)
      @low_address_range = row[3]
      @high_address_range = row[4]
      @odd_even_range = row[5]
      @street_pre_directional_abbr = row[6]
      @street_name = row[7]
      @street_suffix = row[8]
      @street_post_directional = row[9]
      @address_secondary_abbr = row[10]
      @address_secondary_low = row[11]
      @address_secondary_high = row[12]
      @address_secondary_odd_even = row[13]
      @city_name = row[14]
      @zip_code = row[15]
      @plus4 = row[16]
      @zip_code_low = row[17]
      @zip_extension_low = row[18]
      @zip_code_high = row[19]
      @zip_extension_high = row[20]
      @composite_ser_code = row[21]
      @fips_state_code = row[22]
      @fips_state_indicator = row[23]
      @fips_county_code = row[24]
      @fips_place_code = row[25]
      @fips_place_class_code = row[26]
      @longitude_data = row[27]
      @latitude_data = row[28]
      @special_tax_district_code_source_1 = row[29]
      @special_tax_district_code_1 = row[30]
      @type_of_taxing_authority_code_1 = row[31]
      @special_tax_district_code_source_20 = row[32]
      @special_tax_district_code_20 = row[33]
      @type_of_taxing_authority_code_20 = row[34]
    end

    def to_s
      data = [record_type,
              beginning_effective_date,
              ending_effective_date,
              low_address_range,
              high_address_range,
              odd_even_range,
              street_pre_directional_abbr,
              street_name,
              street_suffix,
              street_post_directional,
              address_secondary_abbr,
              address_secondary_low,
              address_secondary_high,
              address_secondary_odd_even,
              city_name,
              zip_code,
              plus4,
              zip_code_low,
              zip_extension_low,
              zip_code_high,
              zip_extension_high,
              composite_ser_code,
              fips_state_code,
              fips_state_indicator,
              fips_county_code,
              fips_place_code,
              fips_place_class_code,
              longitude_data,
              latitude_data,
              special_tax_district_code_source_1,
              special_tax_district_code_1,
              type_of_taxing_authority_code_1,
              special_tax_district_code_source_20,
              special_tax_district_code_20,
              type_of_taxing_authority_code_20]

      "#{data.join(', ')}"
    end

    def state_county_code
      "#{fips_state_code}#{fips_county_code}"
    end

    def state_place_code
      "#{fips_state_code}#{fips_place_code}"
    end

    def self.parse_line_zip(line)
      me = nil
      if line[0] == 'Z' # We are only interested in the Zip records; performance improvement.
        row = line.split(',')
        b = Boundary.new(row)
        me = b if Date.today.between?(b.beginning_effective_date, b.ending_effective_date)
      end
      me
    end

    def self.parse_line_zip4(line)
      me = nil
      if line[0] == '4' # We are only interested in the Zip+4 records; performance improvement.
        row = line.split(',')
        b = Boundary.new(row)
        me = b if Date.today.between?(b.beginning_effective_date, b.ending_effective_date)
      end
      me
    end

  end
end