# frozen_string_literal: true

require 'mellat/version'
require_relative 'mellat/health_check'
require_relative 'mellat/payment_request'
require_relative 'mellat/payment_verification'
require_relative 'mellat/configuration'
require_relative 'mellat/response'
require_relative 'mellat/errors'

require 'savon'
require 'yaml'

module Mellat
  attr_accessor :config

  def self.up?
    Mellat::ClientRequest.new.health_check
  end

  def self.payment_request(params)
    Mellat::PaymentRequest.new.apply(params)
  end

  def self.payment_verify(params)
    Mellat::PaymentVerification.new.verify(params)
  end
end
