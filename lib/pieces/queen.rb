class Queen < Piece
  def initialize(color)
    if color == "white"
      @bitboard = 0b00010000
      @token = "\u2655"
    else
      @bitboard = 0b0001000000000000000000000000000000000000000000000000000000000000
      @token = "\u265B"
    end
    super
  end

  # Generate attack tables
  def attack_mask
    attacks = 0
    if @bitboard != 0
      indicies = get_indicies
      indicies.each do |square|
        temp_board = 1 << square
        a_file = square != 0 ? (square + 1) % 8 : 1
        h_file = square != 0 ? square % 8 : 1
        i = 1
        while i < 8
          attacks |= temp_board << (i * 8) & COMPARISON
          attacks |= temp_board >> (i * 8) & COMPARISON
          attacks |= a_file != 0 ? temp_board << i & COMPARISON : attacks
          attacks |= h_file != 0 ? temp_board >> i & COMPARISON : attacks
          attacks |= a_file != 0 ? temp_board << (i * 9) & COMPARISON : attacks
          attacks |= a_file != 0 ? temp_board >> (i * 7) & COMPARISON : attacks
          attacks |= h_file != 0 ? temp_board >> (i * 9) & COMPARISON : attacks
          attacks |= h_file != 0 ? temp_board << (i * 7) & COMPARISON : attacks
          a_file = a_file != 0 ? (square + i + 1) % 8 : a_file
          h_file = h_file != 0 ? (square - i) % 8 : h_file
          i += 1
        end
      end
    end
    return attacks
  end
end
