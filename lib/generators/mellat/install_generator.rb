# frozen_string_literal: true

require 'rails/generators'
module Mellat
  module Generators
    # Install generator class for mellat gem using in rails
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc 'Mellat Saman initializer for your application'

      def copy_initializer
        template 'mellat_initializer.rb', 'config/initializers/mellat.rb'
      end
    end
  end
end
