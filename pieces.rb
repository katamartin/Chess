class Piece
  DIAG_DELTAS = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
  CART_DELTAS = [ [0, 1], [0, -1], [1, 0], [-1, 0] ]
  attr_reader :board, :pos, :color, :symbol
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @symbol = "X"
  end

  def to_s
    symbol.colorize(color)
  end

  def fail_method
    raise "Not Yet Implemented"
  end

  def possible_moves
    fail_method
  end

  def move_dirs
    fail_method
  end

  def valid_move?(pos)
    board.valid_move?(self.color, pos)
  end

end

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

class Bishop < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = "♝"
  end

  def move_dirs
    DIAG_DELTAS
  end
end

class Rook < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = "♜"
  end

  def move_dirs
    CART_DELTAS
  end
end

class Queen < SlidingPiece
  def initialize(board, pos, color)
    super
    @symbol = "♛"
  end

  def move_dirs
    DIAG_DELTAS + CART_DELTAS
  end
end

class SteppingPiece < Piece
  def moves
    move_set.select { |move| valid_move?(move) }
  end

  def move_set
    delta_set.map { |delta| [delta[0] + pos[0], delta[1] + pos[1]] }
  end
end

class King < SteppingPiece
  def initialize(board, pos, color)
    super
    @symbol = "♚"
  end

  def delta_set
    deltas = DIAG_DELTAS + CART_DELTAS
  end
end

class Knight < SteppingPiece
  def initialize(board, pos, color)
    super
    @symbol = "♞"
  end

  def delta_set
    deltas = [[1, 2], [-1, 2], [-1, -2], [1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end
end

class Pawn < Piece
  attr_reader :origin, :heading
  def initialize(board, pos, color)
    super
    @origin = pos
    @heading = pos.first == 1 ? 1 : -1
    @symbol = "♟"
  end

  def moves
    move_set = []
    delta_set.each do |delta|
      move = [pos[0] + delta[0], pos[1] + delta[1]]
      move_set << move if valid_move?(move)
    end
    attack_set.each do |attack|
      move = [pos[0] + attack[0], pos[1] + attack[1]]
      move_set << move if valid_attack?(move)
    end

    move_set
  end

  def valid_attack?(move)
    board.on_board?(move) && !board[move].empty? && !board.same_color?(color, move)
  end

  def valid_move?(move)
    board.on_board?(move) && board[move].empty?
  end

  def delta_set
    deltas = [[heading, 0]]
    deltas << [heading * 2, 0] if origin == pos
  end

  def attack_set
    [[heading, -1], [heading, 1]]
  end

end
