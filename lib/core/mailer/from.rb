module Core
  module Mailer
    module From
      extend ActiveSupport::Concern

      included do
        # Allows you to set a +from+ address per mailer instance.
        # In ActionMailer the +default+ method sets a class variable so if you change
        # a default it applies to every mailer in the app and you won't be able to
        # set defaults for individual mailers and even individual emails (aka mail methods).
        #
        # This will call the +from+ method when the defaults are read and the mail
        # is prepared. You can overwrite the +from+ method in you mailer or you can
        # set a instance variable <tt>@from</tt> in your mail method to set the
        # default from address for just this email.
        default from: Proc.new { from }
      end

      private
        # This will return nil so no +from+ is set when the instance variable is not
        # defined. You might want to overwrite it in your mailer with the following
        # code instead to return a default from address even if no instance varaiable is set.
        #
        #   def from
        #     @from || "info@example.com"
        #   end
        #
        def from
          @from
        end
    end
  end
end
