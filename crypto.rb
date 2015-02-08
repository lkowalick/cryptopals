# coding: utf-8
require 'pry'
require 'minitest/autorun'

Pry.config.pager = false


def fixed_XOR(string1, string2)
  int1 = Integer(string1, 16)
  int2 = Integer(string2, 16)

  (int1 ^ int2).to_s(16)
end


def average_hamming_distance_for_keysize(keysize)
  base64 = File.read("1_6.txt")
  string = base_64_to_string(base64)
end

def first_four_slices_for_size(string, size)
  (0..3).map do |i|
    string[i*size,size]
  end
end

def char_distribution(string)
  chars = string.scan(/\w/)
  chars.map!(&:downcase)

  distribution = {}

  %w(e t a o i n s h r d l c).each do |char|
    distribution[char] = if chars.length == 0
                           0
                         else
                           chars.count(char).to_f/chars.length*100
                         end
  end

   distribution
end

Class.new(Minitest::Test) do
  def test_char_distribution
    appear_times = {
      "e" => 3,
      "t" => 6,
      "a" => 10,
      "o" => 1,
      "i" => 2,
      'n' => 5,
      's' => 1,
      'h' => 1,
      'r' => 1,
      'd' => 1,
      'l' => 1,
      'c' => 1,
    }

    output = {}

    appear_times.each do |key, val|
      output[key] = val.to_f/appear_times.values.reduce(&:+)*100
    end

    input = ""

    appear_times.each do |key, value|
      input << key * value
    end

    assert_equal(output, char_distribution(input))
  end
end

def score(string)
  distribution = char_distribution(string)

  correct_distribution = {
    'e' => 12.702,
    't' => 9.056,
    'a' => 8.167,
    'o' => 7.507,
    'i' => 6.966,
    'n' => 6.749,
    's' => 6.327,
    'h' => 6.094,
    'r' => 5.987,
    'd' => 4.253,
    'l' => 4.025,
    'c' => 2.782,
  }

  correct_distribution.keys.reduce(0) do |accum, char|
    accum += (distribution[char]/100 - correct_distribution[char]/100)**2
  end
end

def xor_with_character(hex_string, char)
  integer = Integer(hex_string, 16)
  char_int = char.bytes[0]
  bytes = hex_string.each_char.each_slice(2).map do |hex1, hex2|
    Integer(hex1+hex2, 16) ^ char_int
  end
  bytes_to_string(bytes)
end

def best_guess_for_hex_string(hex_string)
  (0..255).map{|l| xor_with_character(hex_string,l.chr)}.max_by{|str| score(str)}
end


def score_for(hex_string)
  score(best_guess_for_hex_string(hex_string))
end

def fixed_xor(string,fixed)
  bytes_to_hex(string.each_char.zip(fixed.each_char.cycle).map{|e| xor_chars(*e)})
end

def new_fixed_xor(string, key)
  string.each_char.zip(key.each_char.cycle).map{|e| xor_chars(*e).chr}.join
end


def xor_chars(char1, char2)
  char1.bytes[0] ^ char2.bytes[0]
end

def hamming_distance(string1, string2)
  zipped = string1.bytes.zip(string2.bytes)
  zipped.map{|e| e[0] ^ e[1]}.map{|e| "%08b" % e}.join.each_char.count{ |e| e == "1" }
end

def hamming_distance_for_key_size(size, string)
  string1 = string[0,size]
  string2 = string[size,size]
  hamming_distance(string1, string2)
end

def average_pairwise_normalized_hamming_distance(array_of_strings)
  total = array_of_strings.combination(2).inject(0) do |accum,(one, two)|
    accum += hamming_distance(one, two)
  end

  Float(total)/array_of_strings[0].length
end


  def test_fixed_xor
    input = <<-EOS
Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal
    EOS
    .chomp, 'ICE'

    output = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

    assert_equal(fixed_xor(*input), output)
  end

  def test_hamming_distance
    input1 = "this is a test"
    input2 = "wokka wokka!!!"

    assert_equal(37, hamming_distance(input1,input2))
    assert_equal(37, hamming_distance(input2,input1))
  end

 
  def test_first_four_slices_for_size
    input = "001002003004005"
    output = ["001","002","003","004"]
    assert_equal(output, first_four_slices_for_size(input, 3))
  end

  def test_average_pairwise_normalized_hamming_distance
    output = 74.0/("this is a test".length)

    input = ["this is a test", "wokka wokka!!!", "wokka wokka!!!"]

    assert_equal(output, average_pairwise_normalized_hamming_distance(input))
  end
end

BestKeysize = Class.new do
  def self.best_keysize
    string = File.read("1_6.txt")
    raw_string = base_64_to_string(string)
    (2..40).map do |ks|
      [ks,average_pairwise_normalized_hamming_distance(first_four_slices_for_size(raw_string, ks))]
    end
  end
end
# It would appear that the keysize is 29?

# Here n should be between 0 and 28
def block_for_position(string, n)
  string.each_char.each_slice(29).map{|slice| slice[n]}.join
end

Class.new(Minitest::Test) do
  def test_block_for_position
    string = "abcdefghijklmnopqrstuvwxyzabc"+
             "ABCDEFGHIJKLMNOPQRSTUVWXYZABC"

    output = { 2 => "cC", 25 => "zZ" }

    [2,25].each do |n|
      assert_equal(output[n], block_for_position(string, n))
    end
  end
end

def score_for_char(string, char)
  score(new_fixed_xor(string, char))
end

Class.new(Minitest::Test) do
  def test_score_for_char
    input = new_fixed_xor("ll\t", "c")

    assert_equal(0.9810521127, score_for_char(input, "c"))
  end
end

def letter_score(string)
  string.each_char.inject(0) do |accum, c|
    c =~ /[:print:]/ ? accum + 1 : accum
  end
end

def best_char_for_string(string)
  accum = []
  (1..255).each do |c|
    accum << [c.chr, score_for_char(string, c.chr), letter_score(new_fixed_xor(string, c.chr))]
  end
  sorted = accum.sort_by {|a| a[1]*1_000_000_000 - a[2]}
  sorted[0][0]
end


Class.new(Minitest::Test) do
  def test_best_char_for_string
    string =
      "Hereupon Legrand arose, with a grave and stately air, and brought me the beetle
from a glass case in which it was enclosed. It was a beautiful scarabaeus, and, at
that time, unknown to naturalists—of course a great prize in a scientific point
of view. There were two round black spots near one extremity of the back, and a
long one near the other. The scales were exceedingly hard and glossy, with all the
appearance of burnished gold. The weight of the insect was very remarkable, and,
taking all things into consideration, I could hardly blame Jupiter for his opinion
respecting it."

    input = new_fixed_xor(string, "c")

    assert_equal("c", best_char_for_string(input))
  end
end

BreakRepeatingXor = Class.new do
  def self.act
    string = base_64_to_string(File.read("1_6.txt").delete("\n"))
    accum = ""
    (0..28).each do |pos|
      blockstring = block_for_position(string, pos)
      char = best_char_for_string(blockstring)

      accum << char
    end
    {
      original_string: string,
      key: accum,
      result: new_fixed_xor(string, accum),
    }
  end
end
