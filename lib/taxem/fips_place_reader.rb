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
        @places[p.state_place_code] = p unless p.nil?
      end
    end

    def place_name_for_boundary(boundary)
      val = nil
      if @places.has_key? boundary.state_place_code
        val = @places[boundary.state_place_code].short_place_name
      end
      val
    end

  end
end
