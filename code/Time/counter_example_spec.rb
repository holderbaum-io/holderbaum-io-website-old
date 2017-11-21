describe TicketInspector do
  let(:inspector) { TicketInspector.new(voucher) }
  let(:bought_at) { Time.now }
  # ...
  describe 'for discounted vouchers' do
    let(:voucher) do
      factory.
        build_discount_voucher(bought_at)
    end
    it 'does not allow usage by default' do
      refute_useability
    end
    describe 'after some amount of time' do
      let(:bought_at) do
        Time.now - days(2)
      end
      it 'does not allow usage' do
        refute_useability
      end
    end
    describe 'after a certain amount of time' do
      let(:bought_at) do
        Time.now - days(2) - second(1)
      end
      it 'does allow usage' do
        assert_useability
      end
    end
  end
  # ...
end
