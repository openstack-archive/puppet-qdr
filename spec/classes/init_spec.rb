require 'spec_helper'
describe 'qdr' do

  context 'with defaults for all parameters' do
    it { should contain_class('qdr') }
  end
end
