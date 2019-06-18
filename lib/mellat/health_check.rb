module Mellat

  class Error < StandardError; end

  class ClientRequest

    def health_check
      authorize_up? && verify_up?
    end

    def authorize_up?
      begin
        client = Savon.client(wsdl: Mellat.configuration.web_service_wsdl)
        expected_operations_for_authorize = %i[bp_cumulative_dynamic_pay_request]
        (expected_operations_for_authorize - client.operations).empty?
      rescue Error
        return false
      end
    end

    def verify_up?
      begin
        client = Savon.client(wsdl: Mellat.configuration.web_service_wsdl)
        expected_operations_for_verify = %i[bp_verify_request]
        (expected_operations_for_verify - client.operations).empty?
      rescue Error
        return false
      end
    end
  end
end
