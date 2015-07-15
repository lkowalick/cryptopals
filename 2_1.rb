require 'pry'
def pkcs_pad(block_of_data, block_length)
  fail 'block of data longer too large' if block_of_data.length > block_length
  difference_in_length = block_length - block_of_data.length
  result = block_of_data
  difference_in_length.times do |i|
    result << difference_in_length.chr
  end
  result
end

binding.pry
