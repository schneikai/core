require 'public_suffix'

class ActionDispatch::Request
  # Returns the top level domain for <tt>request.host</tt>.
  # If no valid tld was found it returns nil.
  # https://github.com/weppos/publicsuffix-ruby Gem.
  def tld
    unless @tld
      PublicSuffix::List.private_domains = false if PublicSuffix::List.private_domains?
      @tld = PublicSuffix.parse(host).tld if PublicSuffix.valid?(host)
      @tld ||= ''
    end
    @tld.presence
  end
end
