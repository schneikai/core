module Core
  module Mailer
    module AttachFromUrl
      extend ActiveSupport::Concern

      private
        # Add a attachment from a given url.
        # This uses <tt>Net::HTTP</tt> do download the url and add the attachment
        # as binary stream.
        #
        # +url+ can be a absolute url or a relative url.
        # If +url+ is relative it uses default <tt>url_options</tt> to make it a
        # absolute url.
        #
        # Remember:
        # If the environment is not +production+ or +staging+ the url is not downloaded
        # instead just a textfile is attached with the url in it. This was added because
        # most development webservers are not multithreaded and they would block if
        # you try to request a url from the local webserver while sending emails.
        def attach_from_url(url)
          unless Rails.env.production? || Rails.env.staging?
            attachments[File.basename(url).gsub(File.extname(url), '.txt')] = url
            return
          end

          uri = URI.parse(custom_url(url))

          # Load the file and add as attachment.
          attachments[File.basename(uri.path)] = Net::HTTP.new(uri.host, uri.port).get(uri.path).body
        end
    end
  end
end
