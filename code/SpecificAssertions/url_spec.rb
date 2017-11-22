# ...

it 'should parse a simple route' do
  assert_equal({ x: '22', y: 'foo' },
               Router.new('/:x/:y').parse('/22/foo'))
end

it 'should parse a prefixed route' do
  assert_equal({ x: 'foo' },
               Router.new('/bar/:x').parse('/bar/foo'))
end

it 'should not parse if the template does not match' do
  assert_equal(nil,
               Router.new('/:x/:y').parse('/foo'))
end

it 'should not parse if the prefix does not match' do
  assert_equal(nil,
               Router.new('/bar/:x').parse('/BAZ/foo'))
end

# ...
