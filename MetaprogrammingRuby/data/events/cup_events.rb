event "the sky is falling" do
  @sky_height < 300
end

event "it's getting closer" do
  @sky_height < @mountain_height
end

setup do
  @sky_height = 100
end

setup do
  @mountain_height = 200
end

