# frozen_string_literal: true

require 'jwt'

class Auth
  ALGORITHM = 'RS256'

  def self.issue(payload)
    JWT.encode(payload, rsa_private, ALGORITHM)
  end

  def self.decode(token)
    Rails.logger.debug(JWT_TOKEN: token)
    JWT.decode(token, rsa_public, true, algorithm: ALGORITHM).first
  rescue => e
    Rails.logger.fatal e
    raise
  end

  def self.rsa_private
    @key ||= OpenSSL::PKey::RSA.new(File.read('jwt_rsa_private.pem'))
  end

  def self.rsa_public
    rsa_private.public_key
  end
end
