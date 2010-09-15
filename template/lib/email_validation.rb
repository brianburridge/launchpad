require 'resolv'

#
# RFC822 Email Address Regex
# --------------------------
# 
# Originally written by Cal Henderson
# c.f. http://iamcal.com/publish/articles/php/parsing_email/
#
# Translated to Ruby by Tim Fletcher, with changes suggested by Dan Kubb.
#
# Licensed under a Creative Commons Attribution-ShareAlike 2.5 License
# http://creativecommons.org/licenses/by-sa/2.5/
RFC822_EmailAddress = begin
  qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
  dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
  atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
    '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
  quoted_pair = '\\x5c[\\x00-\\x7f]'
  domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
  quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
  domain_ref = atom
  sub_domain = "(?:#{domain_ref}|#{domain_literal})"
  word = "(?:#{atom}|#{quoted_string})"
  domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
  local_part = "#{word}(?:\\x2e#{word})*"
  addr_spec = "#{local_part}\\x40#{domain}"
  pattern = /\A#{addr_spec}\z/
end

def validates_email(*attr_names)
  messages = { :valid_format => "Your email address does not appear to be valid", 
               :valid_domain => "Your email domain name appears to be incorrect"}
  # add any custom messages passed as a Hash to the messages Hash
  messages.update(attr_names.pop) if attr_names.last.is_a?(Hash)
  validates_each attr_names do |m, a, v|
    unless v.blank?
      unless v =~ RFC822_EmailAddress
        m.errors.add_to_base(messages[:valid_format])
      else 
        m.errors.add_to_base(messages[:valid_domain]) unless validate_email_domain(v)
      end
    end
  end
end

# validate an email to ensure it has a valid domain
def validate_email_domain(email)
  if defined?(INVALID_EMAIL_DOMAINS)
    INVALID_EMAIL_DOMAINS.each do |invalid_domain|
      return false if email.index(invalid_domain)
    end
  end

  domain = email.match(/\@(.+)/)[1]
  Resolv::DNS.open do |dns|
      @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
  end
  @mx.size > 0 ? true : false
end

