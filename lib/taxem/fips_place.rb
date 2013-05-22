module Taxem
  class FipsPlace

    attr_reader :state,
                :state_fp,
                :place_fp,
                :place_name,
                :type,
                :func_stat,
                :county,
                :row

    def initialize(row)
      @row = row
      i = 0
      @state = row[i]
      @state_fp = row[i+=1]
      @place_fp = row[i+=1]
      @place_name = row[i+=1]
      @type = row[i+=1]
      @func_stat = row[i+=1]
      @county = row[i+=1]
    end

    def self.parse_line(line)
      row = line.split('|')
      me = FipsPlace.new(row)
      me
    end

    def to_s
      data = [state,
              state_fp,
              place_fp,
              place_name,
              type,
              func_stat,
              county]

      "#{data.join(', ')}"
    end

    def fips_place_code
      "#{state_fp}#{place_fp}"
    end
  end
end
