require 'openssl'
require 'base64'

module AES
  module ECB
    # Takes in encrypted data (base64 by default), and decodes it with the
    # given key. Used for completing challenge 1-7
    def self.decrypt(data:,key:, type: :base64)
      decipher = OpenSSL::Cipher.new 'AES-128-ECB'
      decipher.key = key
      decipher.update(Base64.decode64(data)) + decipher.final
    end
  end
end
