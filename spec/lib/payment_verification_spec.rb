require_relative '../../lib/mellat'
require 'savon/mock/spec_helper'

describe Mellat do
  describe ".payment verification" do
    include Savon::SpecHelper

    # set Savon in and out of mock mode
    before(:all) { savon.mock!   }
    after(:all)  { savon.unmock! }

    before(:each) do
      Mellat.configure do |config|
        config.terminal_id = '1527916'
        config.proxy = 'http://148.251.76.196:1088'
        config.username = 'test_username'
        config.password = 'test_password'
      end
    end

    context 'behaviour of payment_request module' do
      let(:params) do
        {
            :order_id => 10,
            :sale_order_id => 10,
            :sale_reference_id => 5142510
        }
      end
      let(:message) do
        {:terminalId=> '1527916', :userName=>'test_username', :userPassword=>'test_password',
         :orderId => 10, :saleOrderId => 10, :saleReferenceId => 5142510}
      end

      it 'unsuccessful mock payment verification to the service' do
        stub_getting_wsdl_definition
        fixture = File.read('spec/mocked_requests/cached_xml/unsuccessful_verify_request.xml')
        savon.expects(:bp_verify_request).with(message: message).returns(fixture)
        expect{ Mellat.payment_verify(params) }.to raise_error(RuntimeError, 'verify request did already!')
      end

      it 'successful mock payment verification to the service' do
        stub_getting_wsdl_definition
        fixture = File.read('spec/mocked_requests/cached_xml/successful_verify_request.xml')
        savon.expects(:bp_verify_request).with(message: message).returns(fixture)
        response = Mellat.payment_verify(params)
        expect(response).to eq(true)
      end

      it 'gets timeout for getting token' do
        mock_authorize_request_timeout
        error_message = 'Mellat is not available right now, calling web service got time out'
        expect{ Mellat.payment_verify(params) }.to raise_error(error_message)
      end
    end
  end
end
