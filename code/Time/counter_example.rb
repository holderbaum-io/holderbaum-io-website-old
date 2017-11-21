class DiscountVoucher
  def initialize(uid, price, bought_at)
    @uid = uid
    @price = price
    @bought_at = bought_at
  end
  # ...
  def discount?
    true
  end

  def bought_at
    @bought_at
  end
  # ...
end

class TicketInspector
  def initialize(voucher)
    @voucher = voucher
  end

  def voucher_useable?
    Time.now > voucher_available_from
  end

  private
  def voucher_available_from
    voucher_bought_at + voucher_blocking_period
  end

  def voucher_bought_at
    @voucher.bought_at
  end


  def voucher_blocking_period
    if @voucher.discount?
      hours_in_seconds(48)
    else
      0
    end
  end
  def hours_in_seconds(hours)
    hours * 60 * 60
  end
end
