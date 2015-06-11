class Array
  def contain? arr
    arr.to_a.each do |a|
      return false unless self.include? a
    end
    return true
  end
end
