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
      @state = row[i].strip
      @state_fp = row[i+=1].strip
      @place_fp = row[i+=1].strip
      @place_name = row[i+=1].strip
      @type = row[i+=1].strip
      @func_stat = row[i+=1].strip
      @county = row[i+=1].strip
    end

    def self.parse_line(line)
      # There are badly encoded characters with accents in this file.
      begin
        row = line.split("|")
        me = FipsPlace.new(row)
        me
      rescue
        # Nothing to do here.
      end
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

    # Strip the legal description off the end of the place name.
    def place_name_no_legal
      words = place_name.split
      words.slice!(-1)
      words.join(' ')
    end

  end
end
