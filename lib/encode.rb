module Encode
  
  NUMERIC_CODE = {
    pawn: 1,
    knight: 2,
    bishop: 3,
    rook: 4,
    queen: 5,
    king: 6
  }
    
  # Generates moves as a bit representation
  # Standard representation:
  # 0000 0000 0000 0000 0011 1111 Origin square
  # 0000 0000 0000 1111 1100 0000 Target square
  # 0000 0000 0111 0000 0000 0000 Piece type
  # 0000 0011 1000 0000 0000 0000 Capture piece type
  # 0001 1100 0000 0000 0000 0000 Promotion piece
  # 0010 0000 0000 0000 0000 0000 En passant
  # 0100 0000 0000 0000 0000 0000 Double Push
  # 1000 0000 0000 0000 0000 0000 Check
  def encode_moves(data)
    moves = []
    data.each do |datum|
      type = NUMERIC_CODE[datum[:code_type]]
      promotion = false
      en_passant = false
      indicies = get_indicies(datum[:moveboard])
      indicies.each do |target|
        if type == 1
          if (target < 64 && target > 56) || (target < 8 && target > -1)
            promotion = 2
          else
            en_passant = encode_en_passant(datum[:origin_square], target, datum[:occupancy])
          end
        end
        moves.push(encode_generated_moves(datum, target, type, promotion, en_passant))
        moves.flatten!
      end
    end
    return moves
  end

  def encode_generated_moves(data, target, type, promotion, en_passant)
    moves = []
    i = promotion ? 5 : 2
    while i > 1
      move = data[:origin_square]
      move |= target << 6
      move |= type << 12
      move |= encode_type(data[:opp_pieces], 1 << target) << 15 if
        (1 << target) & data[:occupancy] > 0
      move |= 1 << 15 if en_passant
      move |= i << 18 if promotion
      move |= 1 << 21 if en_passant
      move |= 1 << 22 if
        type == 1 && (data[:origin_square] - target).abs == 16
      moves.push(move)
      i -= 1
    end
    return moves
  end
  
  def encode_user_move(data)
    piece = NUMERIC_CODE[data[:piece]]
    capture = data[:capture] ? NUMERIC_CODE[data[:capture]] : 0
    promotion = data[:promotion] ? NUMERIC_CODE[data[:promotion]] : 0
    move = data[:origin]
    move |= data[:target] << 6
    move |= piece << 12
    move |= capture << 15
    move |= promotion << 18
    move |= 1 << 21 if data[:en_passant]
    move |= 1 << 22 if
      piece == 1 && (data[:origin] - data[:target]).abs == 16
    return move
  end

  def encode_type(pieces, targetboard)
    pieces.each do |type, piece|
      if targetboard & piece.bitboard > 0
        return NUMERIC_CODE[type.to_sym]
      end
    end
    return nil
  end

  def encode_en_passant(origin, target, occupancy)
    if (target - origin).abs == 7 || (target - origin).abs == 9
      if 1 << target & occupancy == 0
        return true
      else
        return false
      end
    end
  end

  def get_all(move)
    {
      origin: get_origin(move),
      target: get_target(move),
      piece: get_piece_type(move),
      capture: get_capture_type(move),
      promotion: get_promotion_type(move),
      en_passant: en_passant?(move),
      double_push: double_push?(move),
      check: check?(move)
    }
  end

  def get_origin(move)
    move[0..5]
  end

  def get_target(move)
    move[6..11]
  end

  def get_piece_type(move)
    NUMERIC_CODE.key(move[12..14])
  end

  def get_capture_type(move)
    NUMERIC_CODE.key(move[15..17])
  end

  def get_promotion_type(move)
    NUMERIC_CODE.key(move[18..20])
  end

  def en_passant?(move)
    move[21] == 1 ? true : false
  end

  def double_push?(move)
    move[22] == 1 ? true : false
  end

  def check?(move)
    move[23] == 1 ? true : false
  end
end
