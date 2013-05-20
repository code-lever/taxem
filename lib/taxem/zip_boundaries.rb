module Taxem
  class ZipBoundaries
    def initialize
      @by_zip = Hash.new
    end

    def add_boundary(boundary)
      zip_code_low = Integer(boundary.zip_code_low)
      zip_code_high = Integer(boundary.zip_code_high)
      zips = Range.new(zip_code_low, zip_code_high)

      zips.each do |zip|
        @by_zip[zip] = boundary
      end
      self
    end

    def add_boundaries(boundaries)
      boundaries.each do |boundary|
        add_boundary(boundary)
      end
      self
    end

    def for_zip(zip_code)
      @by_zip[zip_code]
    end
  end

end
