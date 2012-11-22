require 'openssl'
require 'logger'
module OTP
  class Secret_Gen
    CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".each_char.to_a
    
    attr_accessor :user
    
    @@logger = Logger.new(STDERR)
    
    def initialize(user=nil)
      begin
        @user = user
      rescue Exception => e
        @@logger.fatal("Failure in initializing Secret generator")
      end
    end
    
    def generate_secret
      begin
        return random_base32(16)
      rescue Exception => e
        @@logger.fatal{"Failure in generating secret: #{e}"}
      end
    end
    
    def random_base32(length=16)
      begin
        b32 = ''
        OpenSSL::Random.random_bytes(length).each_byte do |b|
          b32 << CHARS[b % 62]
        end
        b32
      rescue Exception => e
        @@logger.fatal{"Failure in generating random bytes: #{e}"}
      end
    end
    
  end
end
