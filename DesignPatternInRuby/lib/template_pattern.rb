class Coffee
  def boil_water
  end

  def brew
  end

  def pour_in_cup
  end

  def add_condiment
  end
end

class Tea
  def boil_water
  end

  def brew
  end

  def pour_in_cup
  end

  def add_condiment
  end
end

class CoffeineBeverage
  def initialize material
    @material = material
  end

  def boil_water
    @material.boil_water
  end

  def brew
    @material.brew
  end

  def pour_in_cup
    @material.pour_in_cup
  end

  def add_condiment
    @material.add_condiment
  end
end
