class Money
  def initialize(amount)
    @amount = amount.round(2)
  end

  def +(other)
    sum = amount_of(self) + amount_of(other)
    Money.new sum
  end

  def ==(other)
    amount_of(self) == amount_of(other)
  end

  def inspect
    "#<Money: #{amount_of(self)}>"
  end

  private
  def amount_of(money)
    money.instance_variable_get(:@amount)
  end
end
