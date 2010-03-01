require 'devise/strategies/base'

module Devise
  module Strategies
    # Strategy to connect via facebook_uid if it exists
    class TwitterOauthable < Base
      def valid?
        super && valid_controller? && valid_params? && mapping.to.respond_to?(:authenticate)
      end

      # Authenticate a user based on email and password params, returning to warden
      # success and the authenticated user if everything is okay. Otherwise redirect
      # to sign in page.
      def authenticate!
        if resource = mapping.to.twitter_authenticate(params[scope])
          success!(resource)
        else
          redirect!("/#{scope.to_s.pluralize}/twitter/authorize", params)
        end
      end
      
      protected

        def valid_controller?
          params[:controller] == 'twitter_oauths'
        end

        def valid_params?
          params[scope] && params[scope][:oauth_token].present? #&& params[scope][:oauth_verifier].present?
        end
    end
  end
end

Warden::Strategies.add(:twitter_oauthable, Devise::Strategies::TwitterOAuthable)

#Warden::OAuth.access_token_user_finder(:twitter) do |access_token|
  # NOTE: Normally here you use AR/DM to fetch up the user given an access_token and an access_secret
#  User.new(access_token.token, access_token.secret)
#end
