require 'active_support/all'

module Mellat

  class PaymentRequest
    def apply(params = {})
      config = Mellat.configuration
      request_parameters = create_payment_parameters(params)
      response = send_rest_requests(
          config.web_service_wsdl,
          config.proxy,
          request_parameters,
          config.retry_count
      )
      parse_token_result(response)
    end

    private

    def create_payment_parameters(params = {})
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
      Date.today.in_time_zone('Asia/Tehran').strftime('%Y%m%d')
    end

    def calculate_local_time
      Time.now.in_time_zone('Asia/Tehran').strftime('%H%M%S')
    end

    def send_rest_requests(url, proxy, parameters, retry_to)
      client = Savon.client do
        wsdl url
        proxy proxy
        namespace 'http://interfaces.core.sw.bps.com/'
      end
      return client.call :bp_cumulative_dynamic_pay_request, message: parameters
    rescue Net::OpenTimeout
      retry if (retry_to -= 1).positive?
      return { error: 'Mellat is not available right now, calling web service got time out' }
    rescue StandardError => exception
      retry if (retry_to -= 1).positive?
      return { error: exception.message }
    end

    def parse_token_result(response)
      response_code = response.body[:bp_cumulative_dynamic_pay_request_response][:return]
      status_code = response_code.split(',').first
      return response_code.split(',').last if status_code == '0'
      raise 'server is not capable to response!' if status_code == '34'
      raise 'username or password is invalid!' if status_code == '416'
      raise "Something Weird Happened - your Error code is #{status_code}" \
      "- please check Mellat documentation for more information" unless ['0'].include? status_code
    end
  end
end
