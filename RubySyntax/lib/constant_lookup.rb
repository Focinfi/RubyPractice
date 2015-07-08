module A
  module B; end
  module C
    module D
      B == A::B
    end
  end
end
