class Game
  include Encode, BitManipulations
  attr_reader :board, :to_move

  ENCODE_SQUARES = {
    h1: 0,
    g1: 1,
    f1: 2,
    e1: 3,
    d1: 4,
    c1: 5,
    b1: 6,
    a1: 7,
    h2: 8,
    g2: 9,
    f2: 10,
    e2: 11,
    d2: 12,
    c2: 13,
    b2: 14,
    a2: 15,
    h3: 16,
    g3: 17,
    f3: 18,
    e3: 19,
    d3: 20,
    c3: 21,
    b3: 22,
    a3: 23,
    h4: 24,
    g4: 25,
    f4: 26,
    e4: 27,
    d4: 28,
    c4: 29,
    b4: 30,
    a4: 31,
    h5: 32,
    g5: 33,
    f5: 34,
    e5: 35,
    d5: 36,
    c5: 37,
    b5: 38,
    a5: 39,
    h6: 40,
    g6: 41,
    f6: 42,
    e6: 43,
    d6: 44,
    c6: 45,
    b6: 46,
    a6: 47,
    h7: 48,
    g7: 49,
    f7: 50,
    e7: 51,
    d7: 52,
    c7: 53,
    b7: 54,
    a7: 55,
    h8: 56,
    g8: 57,
    f8: 58,
    e8: 59,
    d8: 60,
    c8: 61,
    b8: 62,
    a8: 63
  }

  RANK = Array('1'..'8')

  FILE = Array('a'..'h')

  CAPTURE = ['x', 'X', ':']

  ENCODE_PIECES = {
    n: :knight,
    b: :bishop,
    r: :rook,
    q: :queen,
    k: :king
  }
  
  def initialize(color = nil)
    @board = Board.new
    @to_move = "white"
    @player_color = color == '1' ? "white" : "black"
    @engine = color ? Engine.new : nil
  end

  def game_loop
    loop do
      #system("clear")
      @board.display_gameboard
      break if game_over?
      print "Move: "
      moves = @board.moves.move_list.map { |move| parse_integer(move) }
      #p moves
      if !@engine || @player_color == @to_move
        move = gets
        move = parse_algebraic(move)
        while !@board.moves.move_list.include?(move)
          print "Illegal move, please try again: "
          move = gets
          move = parse_algebraic(move)
        end
      else
        move = @engine.get_move(@board, @to_move)
      end
      @board.make_move(move, @to_move)
      @to_move = @to_move == "white" ? "black" : "white"
      @board.update(@to_move)
    end
  end

  def game_over?
    if @board.moves.move_list.length == 0
      index = @to_move == "white" ? 0 : 1
      if @board.pieces[index][:king].in_check
        puts index == 1 ? "1-0\nCheckmate" : "0-1\nCheckmate"
      else
        puts "1/2-1/2\nStalemate"
      end
      return true
    elsif insufficient_material?(0) && insufficient_material?(1)
      puts "1/2-1/2\nInsufficient Material"
      return true
    else
      return false
    end
  end

  def insufficient_material?(index)
    counts = @board.piece_counts[index]
    if counts[:queen] == 0 && counts[:rook] == 0 && counts[:pawn] == 0
      if counts[:bishop] == 0
        return true
      elsif counts[:knight] == 0
        if counts[:bishop] == 1
          return true
        else
          indexes = get_indexes(@board.pieces[index][:bishop].bitboard)
          light = false
          dark = false
          indexes.each { |index| index != 0 && index % 2 == 1 ? light = true : dark = true }
          return light && dark ? false : true
        end
      else
        return false
      end
    else
      return false
    end
  end
  
  def parse_algebraic(algebraic)
    data = {  }
    if algebraic == "O-O\n" || algebraic == "O-O-O\n"
      data[:piece] = :king
      if @to_move == "white"
        data[:target] = algebraic == "O-O\n" ? 1 : 5
        data[:origin] = 3
      else
        data[:target] = algebraic == "O-O\n" ? 57 : 61
        data[:origin] = 59
      end
    else
      i = 0
      current = algebraic[i]
      data[:piece] = get_explicit_type(current)
      i += 1 unless data[:piece] == :pawn
      current = algebraic[i]
      data[:disambiguate] = current if RANK.include?(current)
      i += 1 if data[:disambiguate]
      i += 1 if CAPTURE.include?(algebraic[i])
      current = algebraic[i]
      return 1 unless FILE.include?(current)
      i += 1
      i += 1 if CAPTURE.include?(algebraic[i])
      data.merge!(get_user_target(algebraic, i, current))
      return 1 if data[:error]
      data.merge!(get_user_promotion(algebraic, data[:i])) if data[:piece] == :pawn
      return 1 if data[:error]
      data.merge!(get_user_origin(data[:piece], data[:disambiguate], 1 << data[:target]))
      return 2 if data[:error]
      data.merge!(get_user_capture(data[:target], data[:origin], data[:piece]))
    end
    return encode_user_move(data)
  end

  def get_explicit_type(symbol)
    pieces = ['N', 'B', 'R', 'Q', 'K']
    pieces.include?(symbol) ? ENCODE_PIECES[symbol.downcase.to_sym] : :pawn
  end

  def get_user_target(algebraic, i, file)
    data = {  }
    loop do
      current = algebraic[i]
      if RANK.include?(current)
        target = file + current
        target = ENCODE_SQUARES[target.to_sym]
        data[:target] = target
        data[:i] = i + 1
        return data
      elsif FILE.include?(current)
        data[:disambiguate] = file
        file = current
        i += 1
      else
        data[:error] = true
        return data
      end
    end
  end

  def get_user_promotion(algebraic, i)
    data = {  }
    loop do
      current = algebraic[i]
      if current != "\n"
        if current == '='
          data[:promotion] = get_explicit_type(algebraic[i + 1])
          return 1 if data[:promotion] == :pawn || data[:promotion] == :king
          i += 2
        elsif current == '+' || current == '#'
          i += 1
        else
          data[:error] = true
          return data
        end
      else
        return data
      end
    end
  end

  def get_user_origin(piece, disambiguate, target)
    data = {  }
    index = @to_move == "white" ? 0 : 1
    pieceboard = @board.pieces[index][piece].bitboard
    possible_squares = 0
    ENCODE_SQUARES.each do |key, value|
      possible_squares |= 1 << value if
        !disambiguate ||
        key.start_with?(disambiguate) ||
        key.end_with?(disambiguate)
    end
    possible_squares &= pieceboard
    if possible_squares == 0
      data[:error] = true
      return data
    elsif get_indexes(possible_squares).length == 1
      data[:origin] = get_indexes(possible_squares)[0]
      return data
    end
    moves = find_possible_moves(piece, possible_squares, index)
    possible_indexes = []
    moves.each { |move| possible_indexes
                   .push(move[:origin_square]) if move[:moveboard] & target > 0 }
    if possible_indexes.length > 1
      data[:error] = true
    else
      data[:origin] = possible_indexes[0]
    end
    return data
  end

  def get_user_capture(target, origin, piece)
    data = {  }
    opp_pieces = @to_move == "white" ? @board.pieces[1] : @board.pieces[0]
    occupancy = @to_move == "white" ? @board.black_occupancy : @board.white_occupancy
    compare = 0
    if occupancy & 1 << target == 0
      if piece == :pawn && ((target - origin).abs == 7 || (target - origin).abs == 9)
        if double_push?(@board.moves.last_move)
          compare = @to_move == "white" ? 1 << (target - 8) : 1 << (target + 8)
          if compare & (1 << get_target(@board.moves.last_move))
            data[:capture] = :pawn
            data[:en_passant] = true
            return data
          end
        end
      end
    else
      compare = 1 << target
    end
    opp_pieces.each { |type, piece| data[:capture] = type if piece.bitboard & compare > 0 } if
      compare & occupancy > 0
    return data
  end

  def find_possible_moves(piece, squares, index)
    opp_pieces = index == 0 ? @board.pieces[1] : @board.pieces[0]
    board_access = @board.pieces[index]
    same_occupancy = index == 0 ? @board.white_occupancy : @board.black_occupancy
    diff_occupancy = index == 0 ? @board.black_occupancy : @board.white_occupancy
    last_move = @board.moves.game_moves ? @board.moves.game_moves[-1] : nil
    moves = piece == :pawn ?
              board_access[piece].moves(
                same_occupancy, diff_occupancy, opp_pieces, board_access[:king], last_move, squares
              ) :
              board_access[piece].moves(
                same_occupancy, diff_occupancy, opp_pieces, board_access[:king], squares)
    return moves
  end

  def parse_integer(numeric_code)
    codes = get_all(numeric_code)
    algebraic = ""
    algebraic += ENCODE_PIECES.key(codes[:piece]).to_s.upcase unless codes[:piece] == :pawn
    if codes[:capture]
      algebraic += ENCODE_SQUARES.key(codes[:origin]).to_s[0] if codes[:piece] == :pawn
      algebraic += 'x'
    end
    algebraic += ENCODE_SQUARES.key(codes[:target]).to_s
    if codes[:promotion]
      algebraic += '='
      algebraic += ENCODE_PIECES.key(codes[:promotion]).to_s.upcase
    end
    return algebraic
  end
end

