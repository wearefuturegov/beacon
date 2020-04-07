# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'help@beacon.support'
  layout 'mailer'
  helper_method :logo_path

  private

  def load_council_config
    Rails.configuration.councils[ENV['COUNCIL'] || :demo]
  end

  def logo_path
    load_council_config[:logo_path]
  end
end
