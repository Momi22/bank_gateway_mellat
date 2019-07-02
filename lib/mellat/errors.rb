# frozen_string_literal: true

module Mellat
  module Errors
    # List of status code errors and description
    IDS = {
        '31'  => 'Insufficient information',
        '34'  => 'server is not capable to response!',
        '416'  => 'username or password is invalid!',
        '43'  => 'verify request did already!'
    }.freeze
  end
end