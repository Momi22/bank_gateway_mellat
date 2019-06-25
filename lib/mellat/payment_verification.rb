# frozen_string_literal: true

module Mellat
  class PaymentVerification
    def verify(params = {})
      config = Mellat.configuration
      request_parameters = create_verify_parameters(params)
      response = verify_payment(
        config.web_service_wsdl,
        config.proxy,
        request_parameters,
        config.retry_count
      )
      parse_verify_result(response)
    end

    def create_verify_parameters(params = {})
      {
        terminalId: config.terminal_id,
        userName: config.username,
        userPassword: config.password,
        orderId: params[:order_id],
        saleOrderId: params[:sale_order_id],
        saleReferenceId: params[:sale_reference_id]
      }
    end

    def verify_payment(url, proxy, parameters, retry_to)
      client = Savon.client do
        namespace 'http://interfaces.core.sw.bps.com/'
        wsdl url
        proxy proxy
      end
      client.call :bp_verify_request, message: parameters
    rescue Net::OpenTimeout
      retry if (retry_to -= 1).positive?
      { error: 'Mellat is not available right now, calling web service got time out' }
    rescue StandardError => e
      retry if (retry_to -= 1).positive?
      { error: e.message }
    end

    def parse_verify_result(response)
      response_code = response.body[:bp_verify_request][:return]
      status_code = response_code
      return true if status_code == '0'

      raise "Something Went wrong - Error code is #{status_code}" unless \
      ['0'].include? status_code
    end
  end
end
