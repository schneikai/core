module Core
  module Mailer
    module UrlOptions
      extend ActiveSupport::Concern

      # This returns url options that are used to build full urls in emails.
      # You can specify url options for the whole mailer by overwriting this
      # method in your mailer or you can set a instance variable <tt>@url_options</tt>
      # in the mail method to specify url defaults for just this mail. This is useful
      # for example if you need to vary the defaults based on the user you are sending
      # the email to.
      #
      #   def url_options
      #     {
      #       host: 'www.example.com'
      #     }.merge(@url_options || {})
      #   end
      #
      #   def welcome(user)
      #     @url_options = user.url_options
      #     mail to: asset.user.email
      #   end
      #
      # All possible url options:
      #
      #   {
      #     host: 'www.example.com',
      #     port: 3000
      #     scheme: 'http'
      #   }
      def url_options
        super.merge(@url_options || {})
      end
    end
  end
end
