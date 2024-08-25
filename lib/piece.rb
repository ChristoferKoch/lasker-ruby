class Piece
  include Spacing
  
  attr_accessor :color, :bitboard, :attackboard

  NOT_A_FILE = 0b0111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  COMPARISON = 0b1111111111111111111111111111111111111111111111111111111111111111
 
  def initialize(color)
    @color = color
    @attackboard = attack_mask
  end
  
  # Useful for debugging
  def display_bitboard(board)
    bitboard = convert_to_64(board)
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
  #   equivelent of an unsigned long long in C.
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

  # Get the index of each piece on a given bitboard
  def get_indicies
    length = @bitboard.bit_length
    index = 0
    indicies = []
    while index < length
      if @bitboard[index] & 1 == 1
        indicies.push(index)
      end
      index += 1
    end
    return indicies
  end
end
