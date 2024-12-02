class Bishop < Piece
  def initialize(color)
    if color == "white"
      @bitboard = 0b00100100
      @token = "\u2657"
    else
      @bitboard = 0b0010010000000000000000000000000000000000000000000000000000000000
      @token = "\u265D"
    end
    super
  end

  # Generate attack tables
  def attack_mask(bitboard = @bitboard)
    attacks = 0
    if bitboard != 0
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

  # Generate board moves on an otherwise empty board
  def move_mask(board, square)
    moves = 0
    a_file = square != 0 ? (square + 1) % 8 : 1
    h_file = square != 0 ? square % 8 : 1
    i = 1
    while i < 8
      moves |= a_file != 0 ? board << (i * 9) & COMPARISON : moves
      moves |= a_file != 0 ? board >> (i * 7) & COMPARISON : moves
      moves |= h_file != 0 ? board >> (i * 9) & COMPARISON : moves
      moves |= h_file != 0 ? board << (i * 7) & COMPARISON : moves
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
      pieceboard = 1 << piece
      if move_mask(1 << attacker, attacker) & pieceboard > 0
        distance = (piece - attacker).abs
        shift = distance % 7 == 0 ? 7 : 9
        limit = distance / shift
        i = 1
        while i <= limit
          rayboard |= piece > attacker ? pieceboard >> (i * shift) & COMPARISON : pieceboard << (i * shift) & COMPARISON
          i += 1
        end
      end
    end
    return rayboard
  end

  # Adjusts moveboard to deal with blockers
  def unblocked_moves(board, square, blockers, same)
    moves = 0
    a_file = square != 0 ? (square + 1) % 8 : 1
    h_file = square != 0 ? square % 8 : 1
    i = 1
    while i < 8
      nw_block = same[square + (i * 9)] != 1 && blockers[square + ((i - 1) * 9)] != 1 && !nw_block ? false : true
      sw_block = same[square - (i * 7)] != 1 && blockers[square - ((i - 1) * 7)] != 1 && !sw_block ? false : true
      se_block = same[square - (i * 9)] != 1 && blockers[square - ((i - 1) * 9)] != 1 && !se_block ? false : true
      ne_block = same[square + (i * 7)] != 1 && blockers[square + ((i - 1) * 7)] != 1 && !ne_block ? false : true
      moves |= a_file != 0 && !nw_block ? board << (i * 9) & COMPARISON : moves
      moves |= a_file != 0 && !sw_block ? board >> (i * 7) & COMPARISON : moves
      moves |= h_file != 0 && !se_block ? board >> (i * 9) & COMPARISON : moves
      moves |= h_file != 0 && !ne_block ? board << (i * 7) & COMPARISON : moves
      a_file = a_file != 0 ? (square + i + 1) % 8 : a_file
      h_file = h_file != 0 ? (square - i) % 8 : h_file
      i += 1
    end
    return moves
  end
end
