require 'net/http'

CWD = File.expand_path(File.dirname(__FILE__))

require_relative "#{CWD}/../lib/tpx"

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

t2 = Time.now
puts pool.schedule_m_read(mout, 10)
puts (Time.now - t2) * 1000
