class HumanPlayer
  attr_reader :color, :board
  def initialize(board, color)
    @name = "Some Random Player"
    @color = color
    @board = board
  end

  def play_turn
    begin
      start_pos, end_pos = board.position_selection
      valid_piece_check(start_pos)
      board.move(start_pos, end_pos)
    rescue InvalidSelection
      puts "Invalid move. Valid moves highlighted in green."
      retry
    rescue WrongColor
      puts "Please select a #{color.to_s} piece."
      retry
    end
  end

  def valid_piece_check(start_pos)
    raise WrongColor unless board[start_pos].color == color
  end

end
