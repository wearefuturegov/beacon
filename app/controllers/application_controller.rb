# frozen_string_literal: true

require 'errors'

class ApplicationController < ActionController::Base
  before_action :require_user!
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Exceptions::NoValidRoleError, with: :redirect_to_logout

  include Passwordless::ControllerHelpers
  # http_basic_authenticate_with name: 'camden', password: 'camden'
  helper_method :current_user, :current_user_role, :copyright, :council_name, :council_key, :privacy_link, :logo_path, :support_email

  before_action :set_paper_trail_whodunnit

  STALE_ERROR_MESSAGE = 'Error. Somebody else has changed this record, please refresh.'
  
  def healthcheck
    render plain: 'OK'
  end

  def council_key
    ENV['COUNCIL'] || 'demo'
  end

  def council_name
    load_council_config[:name]
  end

  def copyright
    load_council_config[:copyright_notice]
  end

  def privacy_link
    load_council_config[:privacy_link]
  end

  def logo_path
    load_council_config[:logo_path]
  end

  def support_email
    load_council_config[:support_email]
  end

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  private

  def load_council_config
    Rails.configuration.councils[ENV['COUNCIL'] || :demo]
  end

  def require_user!
    return if current_user

    save_passwordless_redirect_location!(User)
    redirect_to auth.sign_in_path
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  def redirect_to_logout
    logger.error "Clearing user session for user with id:#{current_user.id} as no valid role could be found"
    redirect_to auth.sign_out_path
  end
end
