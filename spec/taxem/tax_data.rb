module TaxData
  def boundary_data
    path = Pathname.new("#{File.dirname(__FILE__)}/tax_data/NEB2013Q2FEB25.txt")
    path.realpath
  end
  def rate_data
    path = Pathname.new("#{File.dirname(__FILE__)}/tax_data/NER2013Q2FEB25.txt")
    path.realpath
  end
end
