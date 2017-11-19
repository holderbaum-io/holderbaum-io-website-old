describe RegisterCustomer do
  describe 'with valid data' do
    before do
      @data = {
               :last_name => 'Miller'
              }
    end

    it 'does not fail' do
      register_customer

      assert_success_of_last_call
    end
    # ...
  end

  private
  def register_customer
    request = RegisterCustomer::Request.new(@data)
    @last_call = UseCaseVisitor.new
    RegisterCustomer.call(request, @last_call)
  end

  def assert_success_of_last_name
    assert_predicate @last_call, :success?
  end
  # ...
end
