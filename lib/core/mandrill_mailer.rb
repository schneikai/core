# This module can be included into a CoreMailer to send emails via Mandrill.
#
# Instead of <tt>simple_mail</tt> you use <tt>mandrill_mail</tt> to send emails.
#
#   class MyMailer < ActionMailer::Base
#     include Core::Mailer
#     include Core::MandrillMailer
#
#     def welcome(user)
#       # Add some merge vars
#       mandrill_merge_vars['USERNAME'] = user.username
#
#       # Send the email
#       mandrill_mail user
#     end
#   end
#
# To configure Rails to send mails via Mandrill put the following in your
# +config/environments/development.rb+ (or whatever environment).
#
#   config.action_mailer.delivery_method = :smtp
#   config.action_mailer.raise_delivery_errors = true
#   config.action_mailer.smtp_settings = {
#     address: "smtp.mandrillapp.com",
#     port: 587,
#     enable_starttls_auto: true,
#     user_name: YOUR_MANDRILL_USER_NAME,
#     password: YOUR_MANDRILL_PASSWORD,
#     authentication: 'login'
#   }

module Core::MandrillMailer
  extend ActiveSupport::Concern

  def mandrill_mail(user, options = {}, &block)
    @user = user

    I18n.with_locale(locale) do
      mandrill_default_options options
      mandrill_default_merge_vars options
      headers['X-MC-MergeVars'] = mandrill_merge_vars.to_json

      # When sending mails via Mandrill we want to use the templates we setup
      # in Mandrill/Mailchimp. To stop Rails from throwing MissingTemplate errors
      # because no local template exists we add some text to the body which will
      # make ActionMailers sent this text instead trying to render a template.
      # This text is later replaced by the Mandrill template when the Mandrill
      # SMTP server recieves and processes our email.
      options[:body] ||= "Using Mandrill template #{headers['X-MC-Template']}."

      simple_mail user, options, &block
    end
  end

  private
    def mandrill_default_options(options={})
      headers['X-MC-AutoText'] ||= 1
      headers['X-MC-InlineCSS'] ||= 'true'
      headers['X-MC-Template'] = options.delete(:mandrill_template) || mandrill_template_for(action_name)
    end

    def mandrill_default_merge_vars(options={})
      mandrill_merge_vars['SUBJECT'] = options[:subject] || default_i18n_subject
    end

    # Returns the Mandrill template name for the given action and the current locale.
    #
    # Example: If your App comes in 3 languages: english, german and spanish and
    # your current mailer is +UserMailer+ and the action is +welcome+ make sure
    # you have 3 templates setup in Mandrill:
    #   * user-mailer-register
    #   * user-mailer-register-de
    #   * user-mailer-register-es
    #
    # The template +confirmation-instructions+ (without a locale in the name)
    # is the default language template.
    #
    def mandrill_template_for(action)
      [mailer_name.to_s.dasherize, action_name.to_s.dasherize, mandrill_template_locale].compact.join('-')
    end

    # Returns the locale to be used in the template name. Returns +nil+ if the
    # given locale is the default locale or the given locale is not in the list
    # of available locales.
    def mandrill_template_locale
      unless locale == mandrill_default_locale || (mandrill_available_locales.any? && !mandrill_available_locales.include?(locale))
        locale
      end
    end

    # Returns the default locale for Mandrill templates.
    def mandrill_default_locale
      :en
    end

    # You can return a array of available locales for your Mandrill templates.
    # If a template is requested for a unavilable locale the default locale
    # is used instead.
    def mandrill_available_locales
      []
    end

    # Allows you to set Maindrill merge vars from your mailer method (aka action).
    #
    #   mandrill_merge_vars['EMAIL'] = user.email
    #
    def mandrill_merge_vars
      @mandrill_merge_vars ||= {}
    end
end
