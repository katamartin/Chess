require_relative 'piece'

class SlidingPiece < Piece
  def moves
    directions = move_dirs
    move_set = []
    directions.each do |delta|
      move = [pos[0] + delta[0], pos[1] + delta[1]]
      while valid_move?(move)
        move_set << move
        break unless board[move].empty?
        move = [move[0] + delta[0], move[1] + delta[1]]
      end
    end

    move_set
  end
end
