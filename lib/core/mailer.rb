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
  end
end
