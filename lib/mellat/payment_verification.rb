module Mellat
  class PaymentVerification

    def verify(args = {})
      config = Mellat.configuration
      request_parameters = create_verify_parameters(args)
      response = verify_the_payment(
          config.web_service_wsdl,
          config.proxy,
          request_parameters,
          config.retry_count
      )
      parse_verify_result(response)
    end

    def create_verify_parameters(args = {})
      config = Mellat.configuration
      {
          terminalId: config.terminal_id,
          userName: config.username,
          userPassword: config.password,
          orderId: args[:order_id],
          saleOrderId: args[:sale_order_id],
          saleReferenceId: args[:sale_reference_id]
      }
    end

    def verify_the_payment(url, proxy, parameters, retry_to)
      client = Savon.client do
        wsdl url
        proxy proxy
      end
      return client.call :bp_verify_request, message: parameters
    rescue Net::OpenTimeout
      retry if (retry_to -= 1).positive?
      return { error: 'Mellat is not available right now, calling web service got time out' }
    rescue StandardError => exception
      retry if (retry_to -= 1).positive?
      return { error: exception.message }
    end

    def parse_verify_result(response)
      response_code = JSON.parse(response.body)
      status_code = response_code
      return true if status_code == '0'
      raise "Something Weird Happened - your Error code is #{status_code}" \
      "- please check Mellat documentation for more information" unless ['0'].include? status_code
    end
  end
end
