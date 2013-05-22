module Taxem
  class FipsCounty

    attr_reader :state,
                :state_ansi,
                :county_ansi,
                :county_name,
                :ansi_class,
                :row

    def initialize(row)
      @row = row
      i = 0
      @state = row[i]
      @state_ansi = row[i+=1]
      @county_ansi = row[i+=1]
      @county_name = row[i+=1]
      @ansi_class = row[i+=1]
    end

    def self.parse_line(line)
      row = line.split(',')
      me = FipsCounty.new(row)
      me
    end

    def to_s
      data = [state,
              state_ansi,
              county_ansi,
              county_name,
              ansi_class]

      "#{data.join(', ')}"
    end

    def fips_county_code
      "#{state_ansi}#{county_ansi}"
    end
  end
end
