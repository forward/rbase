Gem::Specification.new do |s|
  s.name = "forward-rbase"
  s.version = "0.2.4"
  s.authors = ["Forward Internet Group"]
  s.date = %q{2011-02-17}
  s.description = "Simple lib for executing hbase lookups"
  s.summary = "Simple lib for executing hbase lookups"
  s.email = "andy@forward.co.uk"
  s.files = [
    "lib/rbase.rb",
    "lib/rbase/client.rb",
    "lib/rbase/table.rb",
    "lib/rbase/thrift/hbase.rb",
    "lib/rbase/thrift/hbase_constants.rb",
    "lib/rbase/thrift/hbase_types.rb",
  ]
  s.homepage = %q{http://github.com/forward/rbase}
  s.require_paths = ["lib"]
  s.rubygems_version = "1.3.5"
  s.add_dependency('thrift', '>= 0.4.0')
end