class Customer
  def initialize(token, goods = [])
    @token = token
    @goods = goods
  end

  def outstanding_amount_to_pay
    @goods.reduce(0) do |total, good|
      total += good.price
    end
  end
  # ...
end
