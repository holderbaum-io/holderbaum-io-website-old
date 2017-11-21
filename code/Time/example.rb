class TicketInspector
  def initialize(voucher, timer = nil)
    @voucher = voucher
    @timer = timer || default_timer
  end

  def voucher_useable?
    current_time > voucher_available_from
  end

  private
  def default_timer
    Proc.new { Time.new }
  end

  def current_time
    @timer.call
  end
  # ...
end
