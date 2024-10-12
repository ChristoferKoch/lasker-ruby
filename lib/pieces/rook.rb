class Rook < Piece
  def initialize(color)
    if color == "white"
      @bitboard = 0b10000001
      @token = "\u2656"
    else
      @bitboard = 0b1000000100000000000000000000000000000000000000000000000000000000
      @token = "\u265C"
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
          a_file = a_file != 0 ? (square + i + 1) % 8 : a_file
          h_file = h_file != 0 ? (square - i) % 8 : h_file
          i += 1
        end
      end
    end
    return attacks
  end

  # Generate moves on an otherwise empty board
  def move_mask(board, square)
    moves = 0
    a_file = square != 0 ? (square + 1) % 8 : 1
    h_file = square != 0 ? square % 8 : 1
    i = 1
    while i < 8
      moves |= board << (i * 8) & COMPARISON
      moves |= board >> (i * 8) & COMPARISON
      moves |= a_file != 0 ? board << i & COMPARISON : moves
      moves |= h_file != 0 ? board >> i & COMPARISON : moves
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
      shift = distance % 8 == 0 ? 8 : 1
      limit = shift == 1 && distance > 8 ? 0 : distance / shift
      i = 1
      while i <= limit
        rayboard |= piece > attacker ? temp_board >> (i * shift) & COMPARISON : temp_board << (i * shift) & COMPARISON
        i += 1
      end
    end
    return rayboard
  end
end
