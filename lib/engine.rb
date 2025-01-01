class Engine
  include BitManipulations, GameOver

  attr_reader :evaluation

  PIECE_VALUES = {
    pawn: {
      d: 200,
      e: 200,
      c: 150,
      f: 150,
      b: 125,
      g: 125,
      a: 50,
      h: 50
    },
    knight: 450,
    bishop: {
      king: 500,
      queen: 450
    },
    rook: {
      king: 700,
      queen: 600
    },
    queen: 1100
  }

  FILE_INDEXES = {
    a: [7, 15, 23, 31, 39, 47, 55, 63],
    b: [6, 14, 22, 30, 38, 46, 54, 62],
    c: [5, 13, 21, 29, 37, 45, 53, 61],
    d: [4, 12, 20, 28, 36, 44, 52, 60],
    e: [3, 11, 19, 27, 35, 43, 51, 59],
    f: [2, 10, 18, 26, 34, 42, 50, 58],
    g: [1,  9, 17, 25, 33, 41, 49, 57],
    h: [0,  8, 16, 24, 32, 40, 48, 56]
  }

  LIGHT_SQUARES = [
     0,  2,  4,  6,  9, 11, 13, 15, 16, 18, 20, 22, 25, 27, 29, 31,
    32, 34, 36, 38, 41, 43, 45, 47, 48, 50, 52, 54, 57, 59, 61, 63
  ]

  KINGSIDE = [
     0,  1,  2,  3,  8,  9, 10, 11, 16, 17, 18, 19, 24, 25, 26, 27,
    32, 33, 34, 35, 40, 41, 42, 43, 48, 49, 50, 51, 56, 57, 58, 59
  ]
  
  def initialize
    # Initial evaluation is equal to the sum of the
    # values Lasker assigned to the first five moves
    @evaluation = 78
  end

  # Depth hardcoded to 4 while debugging
  def minimax(board, to_move, depth = 4)
    move = to_move == "white" ? alpha_beta_max(board, depth, -10000, 10000) : alpha_beta_min(board, depth, -10000, 10000)
    return move[1]
  end

  def alpha_beta_max(board, depth, alpha, beta)
    return [evaluate_board(board), nil] if depth == 0
    game_over_conditions = game_over(board, "white")
    return [game_over_conditions[:result], nil] if game_over_conditions[:game_over]
    value = -10000
    current_move = nil
    move_list = board.moves.generate_moves(
      "white", board.pieces, board.white_occupancy, board.black_occupancy)
    move_list.each do |move|
      current_move = move
      board.make_move(move, "white")
      value = [value, alpha_beta_min(board, depth - 1, alpha, beta)[0]].max
      board.unmake_move
      break if value > beta
      alpha = [alpha, value].max
    end
    return [value, current_move]
  end

  def alpha_beta_min(board, depth, alpha, beta)
    return [evaluate_board(board), nil] if depth == 0
    game_over_conditions = game_over(board, "black")
    return [game_over_conditions[:result], nil] if game_over_conditions[:game_over]
    value = 10000
    current_move = nil
    move_list = board.moves.generate_moves(
      "black", board.pieces, board.white_occupancy, board.black_occupancy)
    move_list.each do |move|
      current_move = move
      board.make_move(move, "black")
      value = [value, alpha_beta_max(board, depth - 1, alpha, beta)[0]].min
      board.unmake_move
      break if value < alpha
      beta = [beta, value].min
    end
    return [value, current_move]
  end

  def evaluate_board(board)
    white_total = side_evaluation(board.pieces[0])
    black_total = side_evaluation(board.pieces[1])
    evaluation = (white_total - black_total) + 78
  end

  def side_evaluation(pieces)
    evaluation = 0
    pieces.each do |type, info|
      case type
      when :pawn
        evaluation += pawn_sum(info.bitboard)
      when :bishop
        evaluation += bishop_sum(info.bitboard, info.token)
      when :rook
        evaluation += rook_sum(info.bitboard)
      when :knight
        evaluation += count_bits(info.bitboard) * PIECE_VALUES[type]
      when :queen
        evaluation += count_bits(info.bitboard) * PIECE_VALUES[type]
      end
    end
    return evaluation
  end

  def pawn_sum(bitboard)
    sum = 0
    indexes = get_indexes(bitboard)
    indexes.each do |index|
      FILE_INDEXES.each do |file, square_array|
        sum += PIECE_VALUES[:pawn][file] if square_array.include?(index)
      end
    end
    return sum
  end

  def bishop_sum(bitboard, token)
    sum = 0
    indexes = get_indexes(bitboard)
    indexes.each do |index|
      if token == "\u2657"
        side = LIGHT_SQUARES.include?(index) ? :king : :queen
      else
        side = LIGHT_SQUARES.include?(index) ? :queen : :king
      end
      sum += PIECE_VALUES[:bishop][side]
    end
    return sum
  end

  def rook_sum(bitboard)
    sum = 0
    indexes = get_indexes(bitboard)
    indexes.each do |index|
      side = KINGSIDE.include?(index) ? :king : :queen
      sum += PIECE_VALUES[:rook][side]
    end
    return sum
  end
end
