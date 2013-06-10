module Taxem
  class ZipBoundaries
    attr_reader :date

    def initialize(date = Date.today)
      @date = date

      # A hash of boundaries mapped by zip code.
      @by_zip = Hash.new
    end

    def add_boundary(boundary)
      zip_code_low = Integer(boundary.zip_code_low)
      zip_code_high = Integer(boundary.zip_code_high)
      zips = Range.new(zip_code_low, zip_code_high)
      zips.each do |zip|
        if @by_zip.has_key? zip
          @by_zip[zip] << boundary
        else
          the_set = Set.new()
          @by_zip[zip] = the_set.add(boundary)
        end
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
      ret_val = nil
      ret_val = @by_zip[zip_code].to_a if @by_zip.has_key? zip_code
      ret_val
    end

    def all_zips
      @by_zip.keys
    end

  end

end
