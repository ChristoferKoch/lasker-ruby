class Bishop < Piece
  def initialize(color)
    if color == "white"
      @bitboard = 0b00100100
      @token = "\u2657"
    else
      @bitboard = 0b00100100000000000000000000000000000000000
      @token = "\u265D"
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

  # Generate empty board moves
  def move_mask()
  end

  # Get attack ray between pieces
  def get_ray(attackers, piece)
    rayboard = 0
    attackers.each do |attacker|
      distance = (piece - attacker).abs
      temp_board = 1 << piece
      shift = distance % 7 == 0 ? 7 : 9
      limit = distance / shift
      i = 1
      while i <= limit
        rayboard |= piece > attacker ? temp_board >> (i * shift) & COMPARISON : temp_board << (i * shift) & COMPARISON
        i += 1
      end
    end
    return rayboard
  end
end
