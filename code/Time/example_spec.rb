describe TicketInspector do
  attr_reader :voucher

  let(:validator) do
    TicketInspector.new(voucher, timer)
  end
  let(:timer) { FakeTimer.new(2014, 07, 14) }

  before do
    @voucher = factory.
      build_discount_voucher(bought_at)
  end

  # ...
  describe 'for discounted vouchers' do
    it 'does not allow usage by default' do
      refute_useability
    end

    describe 'after some amount of time' do
      before do
        timer.advance(days 2)
      end

      it 'does not allow usage' do
        refute_useability
      end
    end

    describe 'after a certain amount of time' do
      before do
        timer.advance(days 2)
        timer.advance(seconds 1)
      end

      it 'does allow usage' do
        assert_useability
      end
    end
  end

  class FakeTimer
    def initialize(*args)
      @time = Time.new(*args).freeze
    end

    def call
      @time
    end

    def advance(seconds)
      @time += seconds
    end
  end
  # ...
end
