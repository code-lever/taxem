module Taxem
  class MagentoWriter

    def initialize(params)
      @taxem = Taxem.new(params)
    end

    def write(path_to_file)
      File.open(path_to_file, 'w') do |f|
        # Write the header
        f.puts Magento.header_to_s

        # Write the state tax rate
        m = Magento.new(@taxem.state_rate)
        f.puts m

        # Write the local tax rates
        zips = @taxem.zip_codes
        zips.each do |zip|
          rate = @taxem.local_rate(zip)
          unless rate.nil?
            m = Magento.new(rate)
            f.puts m
          end
        end
      end
    end

  end
end
