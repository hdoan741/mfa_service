require 'openssl'
require 'logger'

module OTP
  class OTP_Gen
    attr_accessor :secret
    attr_accessor :count
    attr_accessor :digits
    attr_accessor :digest

    @@logger = Logger.new(STDERR)

    def initialize(secret=nil, count=nil, options = {})
      begin 
        @secret = secret
        @count = count
        @digest = options[:digest] || "SHA1"
        @digits = options[:digits] || 6
      rescue Exception => e
        @@logger.fatal{"Failure in initializing OTP: #{e}"}
      end
    end

    def generate_otp
      begin
        @count += 1
        return calculate_hotp(@secret, @count, @digest, @digits)
      rescue Exception => e
        @@logger.fatal{"Failure in generating OTP: #{e}"}
      end
    end

    def calculate_hotp(secret, count, digest, digits)
      return OTP_Gen::hotp(secret, count, digest, digits)
    end

    def self.hotp(secret, count, digest, digits)
      begin
        hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new(digest), secret, string_to_hex_value(count,10))
        offset = hash[-1].chr.hex
        dbc1 = hash[(offset*2)...((offset*2)+8)]
        dbc2 = dbc1.hex & "7fffffff".hex
        hotp = dbc2%(10**digits.to_i)
        otps = "%0#{digits}d" % hotp
        return otps
      rescue Exception => e
        @@logger.fatal{"Failure in calculating HOTP: #{e}"}
      end
    end

    private
    # convert string to hex
    def hexdigest_to_string(string)
      string.unpack('U'*string.length).collect {|x| x.to_s 16}.join
    end
    # convert hex to string
    def hexdigest_to_digest(hex)
      hex.unpack('a2'*(hex.size/2)).collect {|i| i.hex.chr }.join
    end

    def self.string_to_hex_value(count, padding=nil, pad_char="0")
      begin
        hex_count = count.to_i.to_s(16)
        return hex_count
=begin
        return_string = ""
        ((padding.to_i*2) - hex_count.size).times{hex_count.insert(0,pad_char)} if padding
        hex_count = "0" + hex_count if hex_count.size%2==1
        temp_char = "0"
        hex_count.scan(/../).each{ |hexs|
          # temp_char[0] = hexs.hex
          temp_char[0] = hexdigest_to_string(hexs)
          return_string << temp_char
        }
        return return_string
=end
      rescue Exception => e
        @@logger.fatal{"Failure in converting string to hex value Reason #{e.backtrace.join("\n")}"}
      end
    end
  end
end
