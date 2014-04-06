# A mail to test email delivery. Use in the Rails console via
#
#   Core::TestMailer.test('mailbox@example.com').deliver
#
# or via Rake task
#
#   $ bundle exec rake core:test_email[mailbox@example.com]

module Core
  class TestMailer < ActionMailer::Base
    require 'socket'
    include Core::Mailer

    def test(to)
      mail to: to, subject: "Hello from #{Socket.gethostname}", body: "This test email was sent with love from #{Socket.gethostname} (#{local_ip}). Have a nice day!"
    end

    private
      # http://stackoverflow.com/questions/42566/getting-the-hostname-or-ip-in-ruby-on-rails
      def local_ip
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

        UDPSocket.open do |s|
          s.connect '64.233.187.99', 1
          s.addr.last
        end
      ensure
        Socket.do_not_reverse_lookup = orig
      end
  end
end
