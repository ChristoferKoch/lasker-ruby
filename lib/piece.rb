class Piece
  include Spacing
  attr_accessor :color, :bitboard

  def initialize(color)
    @color = color
  end
  
  # Useful for debugging
  def display_bitboard
    puts "#{@bitboard}"
    bitboard = convert_to_64(@bitboard)
    index = 0
    rank = 8

    while rank > 0
      spaced_line = line_spacing(bitboard[index, 8])
      puts "#{rank}  #{spaced_line}"
      index += 8
      rank -= 1
    end

    puts "\n   a b c d e f g h"
  end

  # Create a string to give the binary
  # equivelent of an unsigned long long in C
  def convert_to_64(bitboard)
    bitboard = bitboard.to_s(2)
    difference = 64 - bitboard.length
    leading_bits = ''

    while difference > 0
      leading_bits += '0'
      difference -= 1
    end

    return leading_bits + bitboard
  end
end
