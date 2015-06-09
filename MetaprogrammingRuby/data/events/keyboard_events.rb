setup do
  @button = 105
  @height = 12
end

setup do
  @width = 40
end

event "lose a buuton" do
  104 != @button
end

event "comfortable width" do
  40 == @width
end
