require 'csv'

module Taxem
  class BoundaryReader

    attr_reader :boundaries, :records_in_file, :current_zip_level_records

    def initialize(path_to_csv)
      @boundaries = []
      @records_in_file = 0
      @current_zip_level_records = 0
      IO.foreach(path_to_csv) do |line|
        @records_in_file += 1
        b = Boundary.parse_line(line)
        save_boundary(b) unless b.nil?
      end
    end

    def save_boundary(boundary)
      @current_zip_level_records += 1
      @boundaries << boundary
    end

  end
end
