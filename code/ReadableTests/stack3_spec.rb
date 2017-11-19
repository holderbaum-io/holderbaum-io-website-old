describe Stack do
  # ...
  let(:stack_size) { 2 }
  before do
    @stack = Stack.new(stack_size)
    @stack.push 22
  end

  it 'contains the last pushed element' do
    @stack.push 12

    assert_equal 2, @stack.size
    assert_equal 12, @stack.pop
  end
  # ...
end
