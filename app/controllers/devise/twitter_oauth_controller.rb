class TwitterOauthController < ApplicationController
  include Devise::Controllers::InternalHelpers
  
  before_filter :require_no_authentication, :only => [ :create ]

  def create
    debugger
    re=/\"uid\":(\d+)/
    facebook_uid=nil
    if params[:session]
        facebook_uid = $1.strip if params[:session][re]
    elsif params[:public_session_data]
        facebook_uid = $1.strip if params[:public_session_data][re]
    end
    password="#{facebook_uid}8cb364c5b2885adc3e621bf277144a58#{facebook_uid}"
    params[resource_name] = { 
        :email => "#{facebook_uid}+facebook@20x200.com",
        :password => password,
        :password_confirmation => password,
        :facebook_uid => facebook_uid,
    }
    
    # skip the confirmation. just log them in.
    if build_resource.class.ancestors.include?(Devise::Models::Confirmable)
      resource.skip_confirmation!
    end

    if resource.save
      flash[:"#{resource_name}_signed_up"] = true
      set_flash_message :notice, :signed_up
      sign_in_and_redirect resource_name, resource
    #elsif authenticate! resource.class.name.downcase.to_sym
    elsif resource = authenticate(resource_name)
      flash[:"#{resource_name}_signed_in"] = true
      set_flash_message :notice, :signed_in
      sign_in_and_redirect resource_name, resource
    else
      render_with_scope :new
    end
  end
end