require 'jwt'

hmac_secret = '123'
# in order to use JTI you have to add iat
iat = Time.now.to_i
# Use the secret and iat to create a unique key per request to prevent replay attacks
jti_raw = [hmac_secret, iat].join(':').to_s
jti = Digest::MD5.hexdigest(jti_raw)
jti_payload = { :data => 'data', :iat => iat, :jti => jti }

token = JWT.encode jti_payload, hmac_secret, 'HS256'

begin
  # Add jti and iat to the validation to check if the token has been manipulated
  decoded_token = JWT.decode token, hmac_secret, true, { 'iat' => iat, 'jti' => jti, :verify_jti => true }
  decoded_token = JWT.decode token, hmac_secret, true, { 'iat' => iat, 'jti' => jti, :verify_jti => true }
  # Check if the JTI has already been used
  puts 'hello'
rescue JWT::InvalidJtiError
  # Handle invalid token, e.g. logout user or deny access
  puts 'Error'
end
