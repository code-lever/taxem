require 'csv'

module Taxem
  class RateReader

    attr_reader :rates, :records_in_file, :current_records

    def initialize(path_to_csv)
      @rates = []
      @records_in_file = 0
      @current_records = 0
      IO.foreach(path_to_csv) do |line|
        @records_in_file += 1
        r = Rate.parse_line(line)
        save_rate(r) unless r.nil?
      end
    end

    def save_rate(rate)
      @current_records += 1
      @rates << rate
    end

  end
end
