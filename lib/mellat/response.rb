# frozen_string_literal: true

module Mellat
  class Response
    class ResponseError < RuntimeError; end

    attr_reader :response, :status_code, :refid

    def validate(response = nil)
      @response = response
      perform_validation
    end

    private

    def perform_validation
      raise ArgumentError, 'not a valid response' if @response.nil?

      body = @response[:bp_cumulative_dynamic_pay_request_response] || @response[:bp_verify_request]
      body = body[:return]

      @status_code = body.split(',').first

      if @status_code != '0'
        raise ResponseError, Errors::IDS[@status_code]
      else
        # if we called bp_verify_request it returns 0 anyway!
        # and we can say this is a valid response
        @refid = body.split(',').last
        @refid
      end
    end
  end
end

