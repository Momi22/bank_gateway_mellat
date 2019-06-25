require_relative '../../lib/mellat'

RSpec.describe Mellat do
  before(:each) do
    Mellat.configure {}
    stub_getting_wsdl_definition
  end

  context "health check" do
    it 'is up and working' do
      expect(Mellat.up?).to be true
    end

    it 'gets timeout when tries to reach authorize wsdl' do
      mock_authorize_request_timeout
      expect(Mellat.up?).to be false
    end
  end
end
