class Pawn < Piece
  NOT_A_FILE = 0b111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  
  def initialize(color)
    if color == "white"
      @bitboard = 0b1111111100000000
      @token = "\u2659"
    else
      @bitboard = 0b11111111000000000000000000000000000000000000000000000000
      @token = "\u265F"
    end
    super
  end

  # Generate attack tables
  def attack_mask(bitboard = @bitboard)
    attacks = 0
    if @color == "white"
      attacks = attacks | ((bitboard << 7) & NOT_A_FILE)
      attacks = attacks | ((bitboard << 9) & NOT_H_FILE)
    else
      attacks = attacks | ((bitboard >> 7) & NOT_H_FILE)
      attacks = attacks | ((bitboard >> 9) & NOT_A_FILE)
    end
  end

  def moves(same_occupancy, diff_occupancy, opp_pieces, king, squares = nil)
    moves = []
    indicies = squares ? get_indicies(squares) : get_indicies
    indicies.each do |index|
      moveboard = move_mask(1 << index, index)
      attackboard = attack_mask(1 << index) & ~same_occupancy & diff_occupancy
      pin_check = pinned(same_occupancy | diff_occupancy, opp_pieces, king, index)
      if !pin_check
        blockerboard = (same_occupancy | diff_occupancy) & moveboard
        moveboard ^= blockerboard
        moveboard |= attackboard
        moveboard = king.in_check ? moveboard & king.checkboard : moveboard
      elsif attackboard > 0
        king_distance = (index - king).abs
        if king_distance % 7 != 0 && king_distance % 9 != 0
          moveboard = 0
        else
          shift = king_distance % 7 == 0 ? 7 : 9
          tempboard = @color == "white" ? 1 << (index + shift) : 1 << (index - shift)
          moveboard &= tempboard
        end
      else
        moveboard = 0
      end
      moves.push({
        moveboard: moveboard,
        code_type: self.class.to_s.downcase.to_sym,
        origin_square: index,
        occupancy: diff_occupancy,
        opp_pieces: opp_pieces,
        castle: nil,
        promotion: nil,
        en_passant: false        
      }) if moveboard > 0
    end
    return moves
  end

  def move_mask(bitboard, index)
    moves = 0
    if @color == "white"
      moves |= (bitboard << 8)
      moves |= index > 7 && index < 16 ? (bitboard << 16) : moves
    else
      moves |= (bitboard >> 8)
      moves |= index > 47 && index < 56 ? (bitboard >> 16) : moves
      moves
    end
  end
end
