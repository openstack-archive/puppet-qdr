require 'puppet'
require 'puppet/type/qdr_connector'
describe 'Puppet::Type.type(:qdr_connector)' do
  before :each do
    @qdr_connector = Puppet::Type.type(:qdr_connector).new(:name => 'Conn1', :addr => '127.0.0.1', :port => '5273', :role => 'normal' )
  end

  it 'should require a name' do
  expect {
    Puppet::Type.type(:qdr_connector).new({})
  }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with a whitespace' do
    expect {
      Puppet::Type.type(:qdr_connector).new(:name => 'C onn2')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

end
