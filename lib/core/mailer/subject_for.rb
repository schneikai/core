module Core
  module Mailer
    module SubjectFor
      extend ActiveSupport::Concern

      private
        # Returns a subject for a given action (aka mailer method) by doing an
        # I18n lookup.
        #
        #   en:
        #     mailer:
        #       my_mailer:
        #         my_action:
        #           subject: '...'
        #
        def subject_for(action)
          I18n.t(:subject, scope: [:mailer, mailer_name.underscore, action])
        end
    end
  end
end
