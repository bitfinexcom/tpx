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
