# frozen_string_literal: true

module Mellat
  class PaymentVerification
    attr_reader :response

    def initialize(_args = {})
      @response = Response.new
    end

    def verify(params = {})
      config = Mellat.configuration
      request_parameters = create_verify_parameters(params)
      response = verify_payment(
        config.web_service_url_wsdl,
        config.proxy,
        request_parameters,
        config.retry_count
      )
      verify_valid?(response)
    end

    def create_verify_parameters(params = {})
      config = Mellat.configuration
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
      raise 'Mellat is not available right now, calling web service got time out'
    rescue Savon::HTTPError => e
      retry if (retry_to -= 1).positive?
      Logger.log e.http.code
      raise
    end

    def verify_valid?(response)
      res = @response.validate(response.body)
      if [0, '0'].include? res
        true
      else
        false
      end
    end
  end
end
