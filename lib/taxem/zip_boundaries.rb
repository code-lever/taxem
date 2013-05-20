module Taxem
  class ZipBoundaries
    attr_reader :date

    def initialize(date = Date.today)
      @date = date
      @by_zip = Hash.new
    end

    def add_boundary(boundary)
      if date.between?(boundary.beginning_effective_date, boundary.ending_effective_date)
        zip_code_low = Integer(boundary.zip_code_low)
        zip_code_high = Integer(boundary.zip_code_high)
        zips = Range.new(zip_code_low, zip_code_high)
        zips.each do |zip|
          raise DuplicateZipCodeError if @by_zip.has_key? zip
          @by_zip[zip] = boundary
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
      @by_zip[zip_code]
    end

    def all_zips
      @by_zip.keys
    end

  end

end
