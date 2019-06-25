# frozen_string_literal: true

require 'active_support/core_ext/integer/time.rb'

module Mellat
  class PaymentRequest
    def apply(params = {})
      config = Mellat.configuration
      request_parameters = create_payment_params(params)
      response = send_rest_requests(
       'https://bpm.shaparak.ir/pgwchannel/services/pgw?wsdl',
       config.proxy,
       request_parameters,
       config.retry_count
     )
      parse_token_result(response)
    end

    private

    def create_payment_params(params)
      config = Mellat.configuration
      {
        terminalId: config.terminal_id,
        userName: config.username,
        userPassword: config.password,
        orderId: params[:order_id],
        amount: params[:amount],
        localDate: calculate_local_date,
        localTime: calculate_local_time,
        additionalData: params[:additional_data],
        callBackUrl: params[:redirect_url]
      }
    end

    def calculate_local_date
      Time.now.in_time_zone('Asia/Tehran').strftime('%Y%m%d')
    end

    def calculate_local_time
      Time.now.in_time_zone('Asia/Tehran').strftime('%H%M%S')
    end

    def send_rest_requests(url, proxy, parameters, retry_to)
      client = Savon::client do
        namespace 'http://interfaces.core.sw.bps.com/'
        wsdl url
        proxy proxy
      end
      client.call :bp_cumulative_dynamic_pay_request, message: parameters
    rescue Net::OpenTimeout
      retry if (retry_to -= 1).positive?
      raise 'Saman is not available right now, calling web service got time out'
    rescue Savon::HTTPError => error
      retry if (retry_to -= 1).positive?
      Logger.log error.http.code
      raise
    end

    def parse_token_result(response)
      response_code = response.body[:bp_cumulative_dynamic_pay_request_response][:return]
      status_code = response_code.split(',').first
      return response_code.split(',').last if status_code == '0'
      raise 'server is not capable to response!' if status_code == '34'
      raise 'username or password is invalid!' if status_code == '416'
      raise "Something Went wrong - Error code is #{status_code}"
    end
  end
end
