module Mellat

  class PaymentRequest
    def apply(args = {})
      config = Mellat.configuration
      request_parameters = create_payment_parameters(args)
      response = send_rest_requests(
          config.web_service_wsdl,
          config.proxy,
          request_parameters,
          config.retry_count
      )
      parse_token_result(response)
    end

    private

    def create_payment_parameters(args = {})
      config = Mellat.configuration
      {
          terminalId: config.terminal_id,
          userName: config.username,
          userPassword: config.password,
          orderId: args[:order_id],
          amount: args[:amount],
          localDate: calculate_local_date,
          localTime: calculate_local_time,
          additionalData: args[:additional_data],
          callBackUrl: args[:redirect_url]
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
      response_code = JSON.parse(response.body)
      status_code = response_code.split(',').first
      return response_code.split(',').last if status_code == '0'
      raise 'server is not capable to response!' if status_code == '34'
      raise 'username or password is invalid!' if status_code == '416'
      raise "Something Weird Happened - your Error code is #{status_code}" \
      "- please check Mellat documentation for more information" unless ['0'].include? status_code
    end
  end
end
