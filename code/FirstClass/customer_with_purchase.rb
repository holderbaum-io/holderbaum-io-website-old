class Purchase
  def initialize(goods = [])
    @goods = goods
  end

  def total
    total_goods_value
  end

  def discount
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
end

class Customer
  def initialize(token, purchase = Purchase.new)
    @token = token
    @purchase = purchase
  end

  def outstanding_amount_to_pay
    purchase.total
  end

  def discount_amount
    purchase.discount
  end
  # ...
end
