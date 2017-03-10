require 'openssl'

# 测试 POS机 离线校验能力
#   18位支付码：15位逻辑码，3位校验码
# 运行 ruby e.rb
# 各项测试碰撞概率估计 0.1%

def p
  995397383
end

def ts
  49570969
end

Fixnum.class_eval do
  def to_readable
    ns = self.to_s.chars
    res = ""
    loop do
      res = ns.pop(3).join + res 
      break if ns.size <= 0 
      res = "," + res
    end 
    res
  end
end

Float.class_eval do
  def to_percent
    (self*100).round(2).to_s + "%"
  end
end

def rand_number(n)
  rand(10 ** (n -1) ... 10 ** n)
end

def gen_id
  rand_number(8)
end

def gen_otp
  rand_number(6)
end

def otp_digest(id, otp, t=49570969, digits = 3, padded=true)
  hmac = OpenSSL::HMAC.digest(
    OpenSSL::Digest.new("sha1"),
    id.to_s + otp.to_s,
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

def gen_code(id, o)
  (id + o * p).to_s + otp_digest(id, o)
end

def check_code(code, t=49570969)
  c = code[-3..-1].to_i
  n = code[0..-4].to_i
  o = n/p
  id = n%p

  otp_digest(id, o, t).to_i == c
end

fake_one_char = lambda do |code|
  faked = 0
  count = 0
  code.chars.each_with_index do |c, index|
    (0..9).to_a.each do |n|
      next if n.to_s == c 
      cc = code.dup
      cc[index] = n.to_s
      # puts cc
      if check_code(cc)
        faked += 1 
      end
      count += 1
    end
  end
  [count, faked.to_f/count]
end

fake_two_char = lambda do |code|
  faked = 0
  count = 0
  code.chars.each_with_index do |c, index|
    (0..9).to_a.each do |n|
      next if n.to_s == c 
      c1 = code.dup
      c1[index] = n.to_s
      (index+1...code.size).to_a.each do |i2|
        (0..9).to_a.each do |n2|
          next if n2.to_s == code[i2] 
          c2 = c1.dup
          c2[i2] = n2.to_s
          # puts c2
          if check_code(c2)
            faked += 1 
          end
          count += 1
        end
      end
    end
  end
  [count, faked.to_f/count]
end

def check_tamper(size, n, faker)
  faked = 0
  count = 0
  size.times do
    code = gen_code(gen_id, gen_otp)
    c, probability = faker.call(code)
    count += c
    faked += probability
  end
  
  puts "正确码随机修改 #{n} 位，测试量 #{count.to_readable}，碰撞概率：#{(faked/size).to_percent}"
end

def check_random_hack(size)
  faked = 0
  size.times do
    code = rand_number(18).to_s 
    faked += 1 if check_code(code)
  end

  puts "随机码18位，测试量 #{size.to_readable}，碰撞概率：#{(faked.to_f/size).to_percent }"
end

def check_expiration(size, minutes)
  faked = 0.0
  count = 0
  size.times do
    code = gen_code(gen_id, gen_otp)
    (minutes*2).times do |n|
      count += 1
      faked += 1 if check_code(code, ts + n + 1)
    end 
  end 

  puts "正确码，测试量 #{count.to_readable}，时间区间 #{minutes} 分钟，碰撞概率：#{(faked.to_f/count).to_percent}"
end

# 开始测试
# check_tamper(1000, 1, fake_one_char) # 测试正确码随机修改1位
# check_tamper(10, 2, fake_two_char)   # 测试正确码随机修改1位
# check_random_hack(100_000)           # 测试随机18位
# check_expiration(100, 1_4400)          # 测试正确码时间延后碰撞