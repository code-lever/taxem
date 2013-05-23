module Taxem
  class FipsPlaceReader

    attr_reader :path_to_csv, :records_in_file, :places

    def initialize(path_to_csv)
      @places = Hash.new
      @records_in_file = 0
      @path_to_csv = path_to_csv
      IO.foreach(path_to_csv) do |line|
        @records_in_file += 1
        p = FipsPlace.parse_line(line)
        @places[p.fips_place_code] = p unless p.nil?
      end
    end

  end
end
