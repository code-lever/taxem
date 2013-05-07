module Taxem
  class Rate
    attr_reader :state,
                :jurisdiction_type,
                :jurisdiction_fips_code,
                :general_tax_rate_intrastate,
                :general_tax_rate_interstate,
                :food_drug_tax_rate_intrastate,
                :food_drug_tax_rate_interstate,
                :effective_begin_date,
                :effective_end_date

    def initialize(row)
      i = 0
      @state = row[i]
      @jurisdiction_type = row[i+=1]
      @jurisdiction_fips_code = row[i+=1]
      @general_tax_rate_intrastate = row[i+=1]
      @general_tax_rate_interstate = row[i+=1]
      @food_drug_tax_rate_intrastate = row[i+=1]
      @food_drug_tax_rate_interstate = row[i+=1]
      @effective_begin_date = Date.parse(row[i+=1].to_s)
      @effective_end_date = Date.parse(row[i+=1].to_s)
    end

    def self.parse_line(line)
      me = nil
      row = line.split(',')
      r = Rate.new(row)
      me = r if Date.today.between?(r.effective_begin_date, r.effective_end_date)
      me
    end

  end
end

