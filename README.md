# tpx - a simple fast thread pool implementation

```
require 'net/http'

pool = TPX.new(10)

t1 = Time.now
res = pool.schedule('test') do |args|
  Net::HTTP.get('example.com', '/index.html').size
end

puts res
puts (Time.now - t1) * 1000

sleep 5

mout = pool.schedule_m_build

for kix in 0..10 do
  pool.schedule_m_add([mout, kix, "test#{kix}"]) do |args|
    Net::HTTP.get('example.com', '/index.html').size
  end
end

puts pool.schedule_m_read(mout, 10)
```

```
CWD = File.expand_path(File.dirname(__FILE__))

require_relative "#{CWD}/../lib/tpx"

pool = TPX::Exec.new(2)

t1 = Time.now

prom = TPX::Prom.new(pool)

prom.add([1, 2]) do |a1, a2|
  a1 * a2
end

prom.add([3, 2]) do |a1, a2|
  a1 * a2
end

res = prom.resolve

puts (Time.now - t1) * 1000
puts "#{res}"
```
