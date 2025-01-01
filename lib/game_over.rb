module GameOver
  def game_over(board, to_move)
    response = { game_over: false, result: "" }
    if board.moves.move_list.length == 0
      index = to_move == "white" ? 0 : 1
      response[:game_over] = true
      if board.pieces[index][:king].in_check
        response[:text] = index == 1 ? "1-0\nCheckmate" : "0-1\nCheckmate"
        response[:result] = index == 1 ? 10000 : -10000
      else
        response[:text] = "1/2-1/2\nStalemate"
        response[:result] = 0
      end
    elsif insufficient_material?(board, 0) && insufficient_material?(board, 1)
      response[:game_over] = true
      response[:text] = "1/2-1/2\nInsufficient Material"
      response[:result] = 0
    end
    return response
  end

  def insufficient_material?(board, index)
    counts = board.piece_counts[index]
    if counts[:queen] == 0 && counts[:rook] == 0 && counts[:pawn] == 0
      if counts[:bishop] == 0
        return true
      elsif counts[:knight] == 0
        if counts[:bishop] == 1
          return true
        else
          indexes = get_indexes(board.pieces[index][:bishop].bitboard)
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
end
