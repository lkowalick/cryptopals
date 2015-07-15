#require 'minitest/autorun'
require 'pry'

LOOKUP = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 + /).freeze

def hex_string_to_base_64(hex_string)
  #binding.pry
  string_to_base_64(hex_string_to_string(hex_string))
end

def hex_string_to_string(hex_string)
  [hex_string].pack("H*")
end

def string_to_hex_string(string)
  string.unpack("H*").first
end

def string_to_binary_string(string)
  string.unpack("B*").first
end

def hex_string_to_bytes(hex_string)
  chars = hex_string.each_char.each_slice(2).map do |hex1, hex2|
    Integer(hex1 + hex2, 16)
  end
end

def bytes_to_string(bytes)
  bytes.map(&:chr).join
end

def base_64_to_string(input)
  input.unpack("m").first
end

def string_to_base_64(input)
  [input].pack("m0")
end

def bytes_to_hex(bytes)
  bytes.map{|b| "%02x" % b}.join
end

Class.new(Minitest::Test) do
  def test_hex_string_to_base_64
    input =
"49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    output =
      "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

    assert_equal(output, hex_string_to_base_64(input))
  end
 def test_array_of_integers_to_hex_string
    assert_equal("","")
  end

  def test_base_64_to_string
    output = "any carnal pleasur"
    input = "YW55IGNhcm5hbCBwbGVhc3Vy"
    assert_equal(output, base_64_to_string(input))
  end

  def test_string_to_base_64
    output = "YW55IGNhcm5hbCBwbGVhc3Vy"
    input = "any carnal pleasur"
    assert_equal(output, string_to_base_64(input))
  end
end
