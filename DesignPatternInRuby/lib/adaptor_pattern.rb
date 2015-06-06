module OldWorker
  def faker_add from, to
    from.to_i + to.to_i + rand
  end

  def faker_subtracte from, to
    from.to_i - to.to_i - rand
  end
end

module WorkerAdaptor
  include OldWorker

  def add from, to
    faker_add from, to
  end

  def subtracte from, to
    faker_subtracte
  end
end

class NewCalculator

  def add_calculate
    (1..50).to_a.inject(0) { |result, i| result = add result, i }
  end

  def subtracte_alculate
    (1..50).to_a.inject(0) { |result, i| result = subtracte result, i }
  end
end
