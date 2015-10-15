class Caculater
  def divide(a, b)
    err = nil 
    begin
      res = a/b
    rescue StandardError => e
      err = e
    end
    [res, err]
  end
end

a = 1
b = 0

res, err = Caculater.new.divide(a, b)

if err != nil
  puts "Error: #{err.message}"
else
  puts "#{a}/#{b} = #{res}"
end