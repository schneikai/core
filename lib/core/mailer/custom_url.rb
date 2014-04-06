module Core
  module Mailer
    module CustomUrl
      extend ActiveSupport::Concern

      included do
        helper_method :custom_url
      end

      private
        # Returns a full url for a custom path (non Rails url/route).
        # Uses default <tt>url_options</tt> to build the full url if it is a relative url.
        #
        # custom_url '/script.asp?foo=bar'
        # => "http://www.example.com/script.asp?foo=bar"
        def custom_url(url)
          uri = URI.parse(url)
          url_options.each do |k,v|
            uri.send("#{k}=", v) if uri.respond_to?(k) && uri.send(k).nil?
          end
          uri.scheme ||= 'http'
          uri.to_s
        end
    end
  end
end
