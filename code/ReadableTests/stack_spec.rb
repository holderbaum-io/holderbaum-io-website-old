describe Stack do
  # ...
  before do
    # Arrange is extracted in a setup block
    @stack = Stack.new(2)
    @stack.push 22
  end

  it 'contains the last pushed element' do
    @stack.push 12 # Act is the main operation

    # Assert is split into two physical
    # assertions which makes the intention
    # of the Test Case more clear
    assert_equal 2, @stack.size
    assert_equal 12, @stack.pop
  end
  # ...
end
