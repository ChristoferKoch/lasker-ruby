module DisplayBitboard
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
  
  # Add spacing to make display easier to read
  def line_spacing(unspaced_string, space = true)
    string_arr = unspaced_string.split('')
    count = string_arr.count
    i = 1

    while i < count do
      space ? string_arr.insert(i, ' ') : string_arr.insert(i, ' | ')
      i += 2
      count += 1
    end

    return string_arr.join
  end
end
