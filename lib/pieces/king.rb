class King < Piece
  attr_accessor :in_check, :in_double_check, :checkboard, :castle_permissions
  
  def initialize(color)
    if color == "white"
      @bitboard = 0b00001000
      @token = "\u2654"
    else
      @bitboard = 0b0000100000000000000000000000000000000000000000000000000000000000
      @token = "\u265A"
    end
    @in_check = false
    @in_double_check = false
    @checkboard = 0
    # First bit is queenside, second bit is kingside
    @castle_permissions = 0b11
    super
  end

  # Generate attack tables
  def attack_mask
    attacks = 0
    attacks = attacks | ((@bitboard << 8) & Piece::COMPARISON)
    attacks = attacks | ((@bitboard << 7) & Piece::NOT_A_FILE)
    attacks = attacks | ((@bitboard << 9) & Piece::NOT_H_FILE)
    attacks = attacks | ((@bitboard << 1) & Piece::NOT_A_FILE)
    attacks = attacks | ((@bitboard >> 8) & Piece::COMPARISON)
    attacks = attacks | ((@bitboard >> 7) & Piece::NOT_H_FILE)
    attacks = attacks | ((@bitboard >> 9) & Piece::NOT_A_FILE)
    attacks = attacks | ((@bitboard >> 1) & Piece::NOT_H_FILE)
  end

  def moves(same, diff, opp_pieces)
    moves = []
    moveboard = @attackboard & ~same
    moveboard = safety(moveboard, opp_pieces)
    castle = @castle_permissions > 0 ? true : false
    index = get_indicies
    moves += encode_moves(moveboard, index[0], diff, opp_pieces, castle)
    return moves
  end 

  def safety(board, other_pieces)
    other_pieces.each_value do |piece|
      board ^= piece.attackboard
    end
    return board
  end
end
