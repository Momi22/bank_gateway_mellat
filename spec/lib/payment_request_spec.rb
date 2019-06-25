require_relative '../../lib/mellat'
require 'savon/mock/spec_helper'
require 'active_support/core_ext/integer/time.rb'

describe Mellat do
  describe ".payment request" do
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
      let(:date_time_now) { Time.now.in_time_zone('Asia/Tehran') }
      let(:params) do
        {
            :order_id=>1,
            :amount=>20000,
            :additional_data=>'',
            :redirect_url=>'takhfifan.redirect_url.com'
        }
      end
      let(:message) do
        {:terminalId=> '1527916', :userName=>'test_username', :userPassword=>'test_password', :orderId=>1, :amount=>20000, :localDate=>date_time_now.strftime('%Y%m%d'),
         :localTime=>date_time_now.strftime('%H%M%S'), :additionalData=>"", :callBackUrl=>'takhfifan.redirect_url.com'}
      end

      it 'unsuccessful mock payment request to the service' do
        stub_getting_wsdl_definition
        fixture = File.read('spec/mocked_requests/cached_xml/unsuccessful_payment_request.xml')
        savon.expects(:bp_cumulative_dynamic_pay_request).with(message: message).returns(fixture)
        expect{ Mellat.authorize(params) }.to raise_error(RuntimeError, 'username or password is invalid!')
      end

      it 'successful mock payment request to the service' do
        stub_getting_wsdl_definition
        fixture = File.read('spec/mocked_requests/cached_xml/successful_payment_request.xml')
        savon.expects(:bp_cumulative_dynamic_pay_request).with(message: message).returns(fixture)
        response = Mellat.authorize(params)
        expect(response).to eq('sampleToken')
      end

      it 'gets timeout for getting token' do
        mock_authorize_request_timeout
        error_message = 'Mellat is not available right now, calling web service got time out'
        expect{ Mellat.authorize(params) }.to raise_error(error_message)
      end
    end
  end
end
