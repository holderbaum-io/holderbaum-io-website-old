describe Stack do
  before do
    @stack = Stack.new(size)
  end

  describe 'empty stack' do
    let(:size) { 1 }

    it 'is empty per default' do
      assert_predicate @stack, :empty?
    end

    it 'is not empty after a push' do
      @stack.push 22

      refute_predicate @stack, :empty?
    end
  end

  describe 'filled stack' do
    let(:size) { 1 }

    before do
      @stack.push 78
    end

    it 'pops the pushed element' do
      assert_equal 78, @stack.pop
    end

    it 'pops later added elements first' do
      @stack.push 22

      assert_equal 22, @stack.pop
    end
  end
  # ...
end
