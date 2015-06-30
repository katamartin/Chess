class Piece
  attr_reader :board, :pos, :color
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def possible_moves
    raise "Not Yet Implemented"
  end

  def move_dirs
    raise "Not Yet Implemented"
  end
end

class SlidingPiece < Piece
  DIAG_DELTAS = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
  CART_DELTAS = [ [0, 1], [0, -1], [1, 0], [-1, 0] ]

  def possible_moves
    directions = move_dirs
    moves = []
    directions.each do |delta|
      move = [pos[0] + delta[0], pos[1] + delta[1]]
      while valid_move?(move)
        moves << move
        break unless board[move].empty?
        move = [move[0] + delta[0], move[1] + delta[1]]
      end
    end
    moves
  end

  def valid_move?(pos)
    board.valid_move?(self.color, pos)
  end

end

class Bishop < SlidingPiece
  def move_dirs
    DIAG_DELTAS
  end
end

class Rook < SlidingPiece
  def move_dirs
    CART_DELTAS
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAG_DELTAS + CART_DELTAS
  end
end
