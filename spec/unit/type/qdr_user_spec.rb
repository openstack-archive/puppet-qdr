require 'puppet'
require 'puppet/type/qdr_user'
describe 'Puppet::Type.type(:qdr_user)' do
  before :each do
    @qdr_user = Puppet::Type.type(:qdr_user).new(:name => 'guest', :password => 'guestpw')
  end
  
  it 'should accept a user name' do
    @qdr_user[:name] = 'bob'
    expect(@qdr_user[:name]).to eq('bob')
  end

  it 'should accept a password' do
    @qdr_user[:password] = 'pw'
    expect(@qdr_user[:password]).to eq('pw')
  end
 
  it 'should require a name' do
    expect {
      Puppet::Type.type(:qdr_user).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
end
