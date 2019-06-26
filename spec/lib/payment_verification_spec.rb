require_relative '../../lib/mellat'
require 'savon/mock/spec_helper'

describe Mellat do
  describe ".payment verification" do
    include Savon::SpecHelper

    # set Savon in and out of mock mode
    before(:all) { savon.mock!   }
    after(:all)  { savon.unmock! }

    before(:each) do
      Mellat.configure do |config|
        config.terminal_id = '1527916'
        config.proxy = 'http://148.251.76.196:1088'
        config.username = 'test_username'
        config.password = 'test_password'
      end
    end
  end
end
