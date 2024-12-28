class Pawn < Piece
  NOT_A_FILE = 0b111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  
  def initialize(color)
    if color == "white"
      @bitboard = 0b1111111100000000
      @token = "\u2659"
      @fifth_rank = [32, 33, 34, 35, 36, 37, 38, 39]
      @back_rank = [56, 57, 58, 59, 60, 61, 62, 63]
    else
      @bitboard = 0b11111111000000000000000000000000000000000000000000000000
      @token = "\u265F"
      @fifth_rank = [24, 25, 26, 27, 28, 29, 30, 31]
      @back_rank = [0, 1, 2, 3, 4, 5, 6, 7]
    end
    super
  end

  # Generate attack tables
  def attack_mask(bitboard = @bitboard)
    attacks = 0
    if @color == "white"
      attacks |= ((bitboard << 7) & NOT_A_FILE)
      attacks |= ((bitboard << 9) & NOT_H_FILE)
    else
      attacks |= ((bitboard >> 7) & NOT_H_FILE)
      attacks |= ((bitboard >> 9) & NOT_A_FILE)
    end
  end

  def moves(same_occupancy, diff_occupancy, opp_pieces, king, last_move, squares = nil)
    moves = []
    indexes = squares ? get_indexes(squares) : get_indexes
    indexes.each do |index|
      moveboard = move_mask(1 << index, index)
      attackboard = attack_mask(1 << index) & ~same_occupancy & diff_occupancy
      attackboard |= en_passant(1 << index, last_move) if
        @fifth_rank.include?(index)
      pin_check = pinned(same_occupancy | diff_occupancy, opp_pieces, king, index)
      if !pin_check
        blockerboard = (same_occupancy | diff_occupancy) & moveboard
        moveboard ^= blockerboard
        moveboard |= attackboard
        moveboard = king.in_check ? moveboard & king.checkboard : moveboard
      elsif attackboard > 0
        king_distance = (index - get_indexes(king.bitboard)[0]).abs
        if king_distance % 7 != 0 && king_distance % 9 != 0
          moveboard = 0
        else
          shift = king_distance % 7 == 0 ? 7 : 9
          tempboard = @color == "white" ? 1 << (index + shift) : 1 << (index - shift)
          moveboard = tempboard & attackboard
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
        promotion: nil
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

  def en_passant(bitboard, last_move)
    index = get_indexes(bitboard)[0]
    target = get_target(last_move)
    attack = 0
    if double_push?(last_move) && (target - index).abs == 1
      if target - index == 1
        attack = @color == "white" ? ((bitboard << 9) & NOT_H_FILE)
                 : ((bitboard >> 7) & NOT_H_FILE)
      else
        attack = @color == "white" ? ((bitboard << 7) & NOT_A_FILE)
                 : ((bitboard >> 9) & NOT_A_FILE)
      end
    end
    return attack
  end
end
