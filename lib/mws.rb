require 'rubygems'
require 'httparty'
require 'base64'
require 'cgi'
require 'openssl'
# require 'hashie/mash'
require 'hashie'
require 'rash'

module MWS
  def self.new(options={})
    MWS::Base.new(options.symbolize_keys!)
  end
end

# Some convenience methods randomly put here. Thanks, Rails

class Hash
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end

  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end

class String

  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      self.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      self.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
end

require 'mws/base'
require 'mws/connection'
require 'mws/exceptions'
require 'mws/version'

require 'mws/api/binary_parser'

require 'mws/api/base'
require 'mws/api/inventory'
require 'mws/api/order'
require 'mws/api/product'
require 'mws/api/report'
require 'mws/api/query'
require 'mws/api/response'
require 'mws/api/binary_response'
