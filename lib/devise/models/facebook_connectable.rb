require 'devise/strategies/facebook_connectable'

module Devise
  module Models
    module FacebookConnectable
      
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      protected

      module ClassMethods
        
        def fb_authenticate(attributes={})
          return unless attributes[:facebook_uid]
          conditions = "facebook_uid = '#{attributes[:facebook_uid]}'"
          find_for_authentication(conditions)
        end
        
      end
    end
  end
end
