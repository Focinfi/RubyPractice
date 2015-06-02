class Director
  def self.chief
    @chief ||= self.create_chief
  end
end

class << Director
  def create_chief
    new
  end

  private
  def new
    super
  end
end
