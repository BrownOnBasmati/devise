require 'devise/strategies/twitter_oauthable'

module Devise
  module Models
    module TwitterOauthable
      
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      protected

      module ClassMethods
        
        def twitter_authenticate(attributes={})
          debugger
          return unless attributes[:oauth_token]
          conditions = "oauth_token = '#{attributes[:oauth_token]}'"
          find_for_authentication(conditions)
        end
        
      end
    end
  end
end