require 'puppet'
require 'puppet/type/qdr_address'
describe 'Puppet::Type.type(:qdr_address)' do
  before :each do
    @qdr_address = Puppet::Type.type(:qdr_address).new(:name => 'test', :prefix => 'unicast', :distribution => 'closest' )
  end

  it 'should not expect a prefix with a whitespace' do
    expect {
      Puppet::Type.type(:qdr_address).new(:name => 'test', :prefix => 'multi cast')
    }.to raise_error(Puppet::Error, /Parameter prefix failed/)
  end

end
