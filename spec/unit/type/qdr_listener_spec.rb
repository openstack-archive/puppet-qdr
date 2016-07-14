require 'puppet'
require 'puppet/type/qdr_listener'
describe 'Puppet::Type.type(:qdr_listener)' do
  before :each do
    @qdr_listener = Puppet::Type.type(:qdr_listener).new(:name => 'Listener1', :addr => '127.0.0.1', :port => '5273', :role => 'normal' )
  end

  it 'should require a name' do
  expect {
    Puppet::Type.type(:qdr_listener).new({})
  }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with a whitespace' do
    expect {
      Puppet::Type.type(:qdr_listener).new(:name => 'L istener2')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

end
