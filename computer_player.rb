class ComputerPlayer < HumanPlayer
  PIECE_VALUES = {Pawn => 1, Knight => 2,
                  Bishop => 3, Rook => 4,
                  Queen => 5, King => 6}
  def play_turn
    possible_moves = find_all_moves
    begin
      start_pos, end_pos = pick_move(possible_moves)
      board.move(start_pos, end_pos)
    rescue CheckError
      retry
    end
  end

  def find_all_moves
    pieces = board.teams[color]
    possible_moves = []
    pieces.each do |piece|
      piece.moves.each do |move|
        possible_moves <<  [piece.pos, move]
      end
    end
    possible_moves
  end

  def find_move_values(possible_moves)
    kill_moves = find_kill_moves(possible_moves)
    vulnerable_moves = find_vulnerable_moves(possible_moves)
    values = {}
    possible_moves.each do |move|
      value = 0
      value += PIECE_VALUES[board[move.last].class] if kill_moves.include?(move)
      value -= PIECE_VALUES[board[move.first].class] if vulnerable_moves.include?(move)
      values[move] = value
    end

    values
  end

  def find_kill_moves(possible_moves)
    kills = possible_moves.reject { |move| board[move.last].empty? }
    kills.sort_by! {|move| PIECE_VALUES[board[move.last].class]}

    kills.reverse
  end

  def pick_move(possible_moves)
    values = find_move_values(possible_moves)

    sorted_moves = possible_moves.sort_by{ |m| values[m] }
    move = sorted_moves.pop
    possible_moves.delete(move)

    move
  end


  def find_vulnerable_moves(possible_moves)
    opponent_pieces = board.teams[board.opposite_color(color)]
    possible_moves.select do |move|
      opponent_pieces.any? { |piece| piece.moves.include?(move.last) }
    end
  end

end
