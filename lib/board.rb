class Board
  include DisplayBitboard

  attr_reader :pieces, :white_occupancy, :black_occupancy, :moves

  def initialize
    @pieces = initialize_pieces
    update_occupancy
    @moves = Moves.new(@pieces, @white_occupancy, @black_occupancy)
  end

  def display_gameboard
    @gameboard = Array.new(64, ' ')
    @pieces.each do |color_pieces|
      color_pieces.each_value do |piece|
        piece.get_indicies.each { |index| @gameboard[index] = piece.token }
      end
    end
    print_gameboard
  end

  def print_gameboard
    index = 56
    rank = 8

    puts "   +---+---+---+---+---+---+---+---+"

    while rank > 0
      line = line_spacing(@gameboard[index, 8].reverse.join, false)
      puts "#{rank}  | #{line} |"
      puts "   +---+---+---+---+---+---+---+---+"
      index -= 8
      rank -= 1
    end
    
    puts "\n     a   b   c   d   e   f   g   h"
  end

  def make_move(move, to_move)
    move_data = @moves.get_all(move)
    pieces_index = to_move == "white" ? 0 : 1
    opp_index = to_move == "white" ? 1 : 0
    piece = @pieces[pieces_index][move_data[:piece]]
    capture = move_data[:capture] ? @pieces[opp_index][move_data[:capture]] : nil
    promotion = move_data[:promotion] ? @pieces[pieces_index][move_data[:promotion]] : nil
    update_bitboard(piece, move_data, to_move)
    update_capture(capture, move_data) if capture
    update_promotion(promotion, move_data) if promotion
    @moves.game_moves.push(move)
  end

  def update(to_move)
    update_occupancy
    @moves.generate_moves(to_move, @pieces, @white_occupancy, @black_occupancy)
  end
  #private

  def initialize_pieces
    white_pieces = initialize_color_pieces("white")
    black_pieces = initialize_color_pieces("black")
    [white_pieces, black_pieces]
  end

  def initialize_color_pieces(color)
    {
      pawn: Pawn.new(color),
      knight: Knight.new(color),
      bishop: Bishop.new(color),
      rook: Rook.new(color),
      queen: Queen.new(color),
      king: King.new(color)
    }
  end

  def update_occupancy
    @white_occupancy = calculate_occupancy(@pieces[0])
    @black_occupancy = calculate_occupancy(@pieces[1])
  end

  def calculate_occupancy(color_pieces)
    occupancy = 0
    color_pieces.each_value { |piece| occupancy |= piece.bitboard }
    occupancy
  end

  def update_bitboard(piece, move_data, to_move)
    piece.bitboard ^= 1 << move_data[:origin]
    piece.bitboard |= 1 << move_data[:target]
    piece.attackboard = piece.attack_mask
    if piece.is_a?(King) && (move_data[:origin] - move_data[:target]).abs == 2
      rook = to_move == "white" ? @pieces[0][:rook] : @pieces[1][:rook]
      if move_data[:origin] - move_data[:target] == 2
        rook.bitboard ^= 1 << move_data[:target] - 1
        rook.bitboard |= 1 << move_data[:origin] - 1
      else
        rook.bitboard ^= 1 << move_data[:target] + 2
        rook.bitboard |= 1 << move_data[:origin] + 1
      end
      rook.attackboard = rook.attack_mask
    end
  end

  def update_capture(capture, move_data)
    if move_data[:en_passant]
      shift = to_move == "white" ? move_data[:target] - 8 : move_data[:target] + 8 
      capture.bitboard ^= 1 << shift
    else
      capture.bitboard ^= 1 << move_data[:target]
    end
  end

  def update_promotion(promotion, move_data)
    promotion.bitboard |= 1 << move_data[:target]
  end
end
