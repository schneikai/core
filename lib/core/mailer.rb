module Core
  module Mailer
    extend ActiveSupport::Concern

    autoload :AttachFromUrl, 'core/mailer/attach_from_url'
    autoload :CustomUrl, 'core/mailer/custom_url'
    autoload :From, 'core/mailer/from'
    autoload :UrlOptions, 'core/mailer/url_options'

    included do
      include AttachFromUrl
      include CustomUrl
      include From
      include UrlOptions
    end


    # Sends a mail to the given user.
    # Email address and language are taken from the user model.
    # Subject is automatically taken from I18n.
    def simple_mail(user, options = {}, &block)
      # Current mailer and action name are available via +ActionMailers+
      # <tt>mailer_name</tt> and <tt>action_name</tt>
      #
      # Subject defaults to ActionMailers <tt>default_i18n_subject</tt>
      # which uses:
      #   en:
      #     mailer_name:
      #       action_name:
      #         subject: '...'

      @user = user

      options[:to] ||= user.email

      I18n.with_locale(locale) do
        mail options, &block
      end
    end

    private
      # Returns the reciepient that was set in <tt>simple_mail</tt> method.
      def user
        @user
      end

      # Returns the locale for the mailer. The method tries to read a +locale+
      # attribute from the user model (recipient) if such attribute does not
      # exist it returns the current locale.
      def locale
        (user.try(:locale) || I18n.locale).to_sym
      end

  end
end
