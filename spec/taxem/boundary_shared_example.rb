require 'spec_helper'

shared_examples 'a boundary for ZipBoundaries' do
  it { should respond_to :zip_code_low }
  it { should respond_to :zip_code_high }
end
