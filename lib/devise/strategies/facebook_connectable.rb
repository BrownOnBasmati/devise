require 'devise/strategies/base'

module Devise
  module Strategies
    # Strategy to connect via facebook_uid if it exists
    class FacebookConnectable < Base
      def valid?
        super && valid_controller? && valid_params? && mapping.to.respond_to?(:authenticate)
      end

      # Authenticate a user based on email and password params, returning to warden
      # success and the authenticated user if everything is okay. Otherwise redirect
      # to sign in page.
      def authenticate!
        if resource = mapping.to.fb_authenticate(params[scope])
          success!(resource)
        else
          redirect!("/#{scope.to_s.pluralize}/fb/connect", params)
        end
      end
      
      protected

        def valid_controller?
          params[:controller] == 'facebook_connects'
        end

        def valid_params?
          params[scope] && params[scope][:facebook_uid].present?
        end
    end
  end
end

Warden::Strategies.add(:facebook_connectable, Devise::Strategies::FacebookConnectable)
