class Knight < Piece
  NOT_AB_FILE = 0b11111100111111001111110011111100111111001111110011111100111111
  NOT_GH_FILE = 0b1111110011111100111111001111110011111100111111001111110011111100
  
  def initialize(color)
    if color == "white"
      @bitboard = 0b01000010
      @token = "\u2658"
    else
      @bitboard = 0b0100001000000000000000000000000000000000000000000000000000000000
      @token = "\u265E"
    end
    super
  end

  def attack_mask(bitboard = @bitboard)
    attacks = 0
    attacks |= ((bitboard << 15) & NOT_A_FILE)
    attacks |= ((bitboard << 17) & NOT_H_FILE)
    attacks |= ((bitboard << 10) & NOT_GH_FILE)
    attacks |= ((bitboard << 6) & NOT_AB_FILE)
    attacks |= ((bitboard >> 15) & NOT_H_FILE)
    attacks |= ((bitboard >> 17) & NOT_A_FILE)
    attacks |= ((bitboard >> 10) & NOT_AB_FILE)
    attacks |= ((bitboard >> 6) & NOT_GH_FILE)
  end

  def moves(same_occupancy, diff_occupancy, opp_pieces, king, squares = nil)
    moves = []
    indicies = squares ? get_indicies(squares) : get_indicies
    indicies.each do |index|
      moveboard = move_mask(1 << index, index)
      pin_check = pinned(same_occupancy | diff_occupancy, opp_pieces, king, index)
      if !pin_check && king.checkboard == 0
        if moveboard && king.checkboard > 0
          moveboard = king.in_check ? 0 : pin_check | moveboard
        else
          blockerboard = moveboard & same_occupancy
          moveboard = moveboard ^ blockerboard
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
    moves |= ((bitboard << 15) & NOT_A_FILE)
    moves |= ((bitboard << 17) & NOT_H_FILE)
    moves |= ((bitboard << 10) & NOT_GH_FILE)
    moves |= ((bitboard << 6) & NOT_AB_FILE)
    moves |= ((bitboard >> 15) & NOT_H_FILE)
    moves |= ((bitboard >> 17) & NOT_A_FILE)
    moves |= ((bitboard >> 10) & NOT_AB_FILE)
    moves |= ((bitboard >> 6) & NOT_GH_FILE)
  end
end
