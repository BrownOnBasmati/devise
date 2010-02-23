require 'devise/strategies/facebook_connectable'

module Devise
  module Models

    # FacebookConnectable Module, responsible for encrypting password and validating
    # authenticity of a user while signing in.
    #
    module FacebookConnectable
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      protected

      module ClassMethods
        # Authenticate a user based on configured attribute keys. Returns the
        # authenticated user if it's valid or nil. Attributes are by default
        # :email and :password, but the latter is always required.
        def fb_authenticate(attributes={})
          return unless attributes[:facebook_uid]
          conditions = "facebook_uid = '#{attributes[:facebook_uid]}'"
          find_for_authentication(conditions)
        end
      end
    end
  end
end
