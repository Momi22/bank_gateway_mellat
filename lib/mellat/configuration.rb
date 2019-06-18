require_relative './../initializer/mellat'

module Mellat

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :terminal_id, :username, :password, :proxy, :retry_count, :web_service_wsdl

    def retry_count
      @retry_count || 3
    end

    def web_service_wsdl
      @web_service_wsdl || 'https://bpm.shaparak.ir/pgwchannel/services/pgw?wsdl'
    end
  end
end
