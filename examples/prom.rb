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
