# Validates whether the value of the specified attribute matches the format of an URL,
# as defined by RFC 2396. See URI#parse for more information on URI decompositon and parsing.
#
# This method doesn't validate the existence of the domain, nor it validates the domain itself.
#
# Allowed values include http://foo.bar, http://www.foo.bar and even http://foo.
# Please note that http://foo is a valid URL, as well http://localhost.
# It's up to you to extend the validation with additional constraints.
#
#   class Site < ActiveRecord::Base
#     validates_format_of :url, :on => :create
#     validates_format_of :ftp, :schemes => [:ftp, :http, :https]
#   end
#
# ==== Configurations
#
# * :schemes - An array of allowed schemes to match against (default is [:http, :https])
# * :message - A custom error message (default is: "is invalid").
# * :allow_nil - If set to true, skips this validation if the attribute is +nil+ (default is +false+).
# * :allow_blank - If set to true, skips this validation if the attribute is blank (default is +false+).
# * :on - Specifies when this validation is active (default is :save, other options :create, :update).
# * :if - Specifies a method, proc or string to call to determine if the validation should
#   occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }).  The
#   method, proc or string should return or evaluate to a true or false value.
# * :unless - Specifies a method, proc or string to call to determine if the validation should
#   not occur (e.g. :unless => :skip_validation, or :unless => Proc.new { |user| user.signup_step <= 2 }).  The
#   method, proc or string should return or evaluate to a true or false value.
#
def validates_format_of_url(*attr_names)
  require 'uri/http'

  configuration = { :on => :save, :schemes => %w(http https) }
  configuration.update(attr_names.extract_options!)

  allowed_schemes = [*configuration[:schemes]].map(&:to_s)

  validates_each(attr_names, configuration) do |record, attr_name, value|
    begin
      if value.present?
        uri = URI.parse(value)

        if !allowed_schemes.include?(uri.scheme)
          raise(URI::InvalidURIError)
        end

        if [:scheme, :host].any? { |i| uri.send(i).blank? }
          raise(URI::InvalidURIError)
        end
      end

    rescue URI::InvalidURIError => e
      record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
      next
    end
  end
end