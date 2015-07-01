class ComputerPlayer < HumanPlayer

  def play_turn
    pieces = board.teams[color]
    possible_moves = []
    pieces.each do |piece|
      piece.moves.each do |move|
        possible_moves <<  [piece.pos, move]
      end
    end
    begin
      start_pos, end_pos = possible_moves.sample
      board.move(start_pos, end_pos)
    rescue CheckError
      possible_moves.delete([start_pos, end_pos])
      retry
    end
  end
end
