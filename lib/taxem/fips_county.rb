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
      @state = row[i].strip
      @state_ansi = row[i+=1].strip
      @county_ansi = row[i+=1].strip
      @county_name = row[i+=1].strip
      @ansi_class = row[i+=1].strip
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

    def state_county_code
      "#{state_ansi}#{county_ansi}"
    end

    def short_county_name
      # Drop the last word, its always "County"
      words = county_name.split
      words.slice!(-1) if words.count > 1
      words.join(' ')
    end

  end
end
