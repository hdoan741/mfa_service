require 'OTP'
require 'rubygems'

username = "39u39ur2@gmail.com"
count = 30

s = OTP::Secret_Gen.new(username)
secret = s.generate_secret
puts("[secret: #{secret}]")

h = OTP::OTP_Gen.new(secret,10)
puts("[otp0: #{h.generate_otp}]")

(0..20).each{ |c|
  h.count = c
  puts("[otp#{c+1}: #{h.generate_otp}]")
}