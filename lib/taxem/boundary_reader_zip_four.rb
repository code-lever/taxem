module Taxem
  class BoundaryReaderZipFour < BoundaryReaderZip
    def parse_boundary_from_line(line)
      b = Boundary.parse_line_zip4(line)
    end
  end
end
