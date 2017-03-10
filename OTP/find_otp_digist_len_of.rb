require 'openssl'

# otp_digest generates otp
def otp_digest(key, t, digits: 6, padded: true)
  hmac = OpenSSL::HMAC.digest(
    OpenSSL::Digest.new("sha1"),
    key,
    int_to_bytestring(t)
  )

  offset = hmac[-1].ord & 0xf
  code = (hmac[offset].ord & 0x7f) << 24 |
    (hmac[offset + 1].ord & 0xff) << 16 |
    (hmac[offset + 2].ord & 0xff) << 8 |
    (hmac[offset + 3].ord & 0xff)
  if padded
    (code % 10 ** digits).to_s.rjust(digits, '0')
  else
    code % 10 ** digits
  end
end

def int_to_bytestring(int, padding = 8)
  result = []
  until int == 0
    result << (int & 0xFF).chr
    int >>=  8
  end
  result.reverse.join.rjust(padding, 0.chr)
end

def find_otp_digist_len_of(l, from: Time.now.to_i, key: "")
  base = from/30   

  loop {
    otp = otp_digest(key, base, padded: false)    
    return [otp, Time.at(base*30)] if otp.to_s.length == l
    # puts otp
    base += 1
  }
end

puts find_otp_digist_len_of(1, key: "073ce5df-493b-40ea-81c8-65affc4517e4") 