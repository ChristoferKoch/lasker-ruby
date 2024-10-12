class Queen < Piece
  def initialize(color)
    if color == "white"
      @bitboard = 0b00010000
      @token = "\u2655"
    else
      @bitboard = 0b0001000000000000000000000000000000000000000000000000000000000000
      @token = "\u265B"
    end75757
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

  # Get moves on an otherwise empty board
  def move_mask(board, square)
    moves = 0
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
    return moves
  end

  # Get attack ray between pieces
  def get_ray(attackers, piece)
    rayboard = 0
    attackers.each do |attacker|
      distance = (piece - attacker).abs
      temp_board = 1 << piece
      if distance % 8 == 0
        shift = 8
      elsif distance % 9 == 0
        shift = 9
      elsif distance % 7 == 0
        shift = distance == 7 && diagonal?(attacker, piece) ? 7 : 1
      else
        shift = 1
      end
      limit = shift == 1 && distance > 8 ? 0 : distance / shift
      i = 1
      while i <= limit
        rayboard |= piece > attacker ? temp_board >> (i * shift) & COMPARISON : temp_board << (i * shift) & COMPARISON
        i += 1
      end
    end
    return rayboard
  end

  # Determines if piece with distance of 7 is on the same rank or diagonal
  # as the queen
  def diagonal?(queen, target)
    queen_board = 1 << queen
    if queen > target && (queen_board & NOT_A_FILE) > 0
      return true
    elsif queen < target && (queen_board & NOT_H_FILE) > 0
      return true
    else
      return false
    end
  end
end
