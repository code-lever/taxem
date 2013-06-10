require 'csv'

module Taxem
  class BoundaryReaderZip

    attr_reader :boundaries, :records_in_file, :record_count

    def initialize(path_to_csv)
      @boundaries = []
      @records_in_file = 0
      @record_count = 0
      IO.foreach(path_to_csv) do |line|
        @records_in_file += 1
        b = parse_boundary_from_line(line)
        save_boundary(b) unless b.nil?
      end
    end

    def save_boundary(boundary)
      @record_count += 1
      @boundaries << boundary
    end

    def parse_boundary_from_line(line)
      b = Boundary.parse_line_zip(line)
    end

  end
end
