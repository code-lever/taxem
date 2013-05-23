module Taxem
  class FipsCountyReader

    attr_reader :path_to_csv, :records_in_file, :counties

    def initialize(path_to_csv)
      @counties = Hash.new
      @records_in_file = 0
      @path_to_csv = path_to_csv
      IO.foreach(path_to_csv) do |line|
        @records_in_file += 1
        c = FipsCounty.parse_line(line)
        @counties[c.fips_county_code] = c
      end
    end

  end
end
