# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_user!

  include Passwordless::ControllerHelpers
  # http_basic_authenticate_with name: 'camden', password: 'camden'
  helper_method :current_user, :copyright, :council_name, :council_key, :privacy_link, :logo_path

  before_action :set_paper_trail_whodunnit

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
end
