module Taxem
  class MagentoWriter

    def initialize(params)
      @taxem = Taxem.new(params)
    end

    def write(path_to_file)
      File.open(path_to_file, 'w') do |f|
        f.puts Magento.header_to_s
        zips = @taxem.zip_codes
        zips.each do |zip|
          ri = @taxem.rate(zip)
          m = Magento.new(ri)
          f.puts m
        end
      end
    end

  end
end
