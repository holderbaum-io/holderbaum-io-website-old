# ...

it 'should parse a simple route' do
  assert_parsed_route('/:x/:y', '/22/foo',
                      x: '22', y: 'foo')
end

it 'should parse a prefixed route' do
  assert_parsed_route('/bar/:x', '/bar/foo',
                      x: 'bar')
end

it 'should not parse if the template does not match' do
  refute_parsed_route('/:x/:y', '/foo')
end

it 'should not parse if the prefix does not match' do
  refute_parsed_route('/bar/:x', '/BAZ/foo')
end

# ...

def parse_url(route_pattern, url)
  router = Router.new(route_pattern)
  router.parse(url)
end

def assert_parsed_route(route_pattern, url, expected_result)
  result = parse_url(route_pattern, url)
  msg = "Expected '#{route_pattern}' to match #{url}"
  assert_equal(expected_result,
               result,
               msg)
end

def refute_parsed_route(route_pattern, url)
  result = parse_url(route_pattern, url)
  msg = "Expected '#{route_pattern}' to not match #{url}"
  assert_equal(nil,
               result,
               msg)
end

# ...
