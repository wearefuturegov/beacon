module Passwordless
    # The mailer responsible for sending Passwordless' mails.
    class Mailer < GovukNotifyRails::Mailer
      default from: Passwordless.default_from_address
  
      # Sends a magic link (secret token) email.
      # @param session [Session] A Passwordless Session
      def magic_link(session)
        @session = session
  
        @magic_link = send(Passwordless.mounted_as)
          .token_sign_in_url(session.token)
  
        email_field = @session.authenticatable.class.passwordless_email_field

        # mail(
        #   to: @session.authenticatable.send(email_field),
        #   subject: I18n.t("passwordless.mailer.subject")
        # )

        set_template('2305fb7b-6a7b-4b03-8cdd-a01743511286')
        set_personalisation(
          magic_link: @magic_link
        )
        mail(:to => @session.authenticatable.send(email_field))

      end
    end
  end