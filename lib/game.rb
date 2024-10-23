class Game
  attr_reader :board, :to_move, :game_over
  
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

  ENCODE_PIECES = {
    n: 'knight',
    b: 'bishop',
    r: 'rook',
    q: 'queen',
    k: 'king'
  }
  
  def initialize
    @board = Board.new
    @to_move = 'white'
    @game_over = false
  end

  def game_loop
    loop do
      @board.display_gameboard
      @board.move_list
      puts "Move:"
      move = gets
      move = move.to_i
      while !@board.move_list.include?(move)
        puts "Illegal move, please try again:"
        move = gets
        move = move.to_i
      end
      @board.make_move(move)
      @to_move = @to_move == 'white' ? 'black' : 'white'
      @board.occupancy
      @board.move_list = @board.generate_moves(@to_move)
      @game_over = true if @board.move_list.length == 0
      p @board.move_list.length
      break
    end
  end
end

