require 'pry'
require './open_ssl.rb'
require './crypto.rb'
require './conversion.rb'

lines = File.read('data/1_8.txt').each_line.map(&:chomp)
offset = 32

found = lines.select do |line|
  blocks = 10.times.map do |i|
    line[i*offset, offset]
  end
  blocks.combination(2).any? do |(block1, block2)|
    block1 == block2
  end
end
