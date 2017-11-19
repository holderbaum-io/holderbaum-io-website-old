class Customer
  # ...
  def outstanding_amount_to_pay
    total_goods_value
  end

  def discount_amount
    if discount?
      15
    else
      0
    end
  end

  private
  def discount?
    total_goods_value > 100
  end

  def total_goods_value
    @goods.reduce #...
  end
  # ...
end
