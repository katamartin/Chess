require_relative 'pieces'
require_relative 'empty_square'
require 'colorize'
require 'io/console'

class Board
  attr_reader :grid
  attr_accessor :cursor
  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @cursor = [0, 0]
    populate
  end

  def populate_big_row(color, row)
    big_row = []
    big_row << Rook.new(self, [row, 0], color)
    big_row << Knight.new(self, [row, 1], color)
    big_row << Bishop.new(self, [row, 2], color)
    big_row << King.new(self, [row, 3], color)
    big_row << Queen.new(self, [row, 4], color)
    big_row << Bishop.new(self, [row, 5], color)
    big_row << Knight.new(self, [row, 6], color)
    big_row << Rook.new(self, [row, 7], color)
    grid[row] = big_row
  end

  def populate_pawn_row(color, row)
    grid[row].map!.with_index { |_, i| Pawn.new(self, [row, i], color) }
  end

  def populate
    populate_big_row(:black, 0)
    populate_pawn_row(:black, 1)
    populate_big_row(:white, 7)
    populate_pawn_row(:white, 6)
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def valid_move?(color, pos)
    return false unless on_board?(pos)
    return true if self[pos].empty?

    !same_color?(color, pos)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def same_color?(color, pos)
    self[pos].color == color
  end

  def move_cursor(pos)
    new_position = [cursor[0] + pos[0], cursor[1] + pos[1]]
    self.cursor = new_position if on_board?(new_position)
    system("clear")
    render
  end

  def render
    puts "   #{("a".."h").to_a.join("  ")}"
    grid.each_with_index do |row, i|
      print "#{i} "
      row.each_with_index do |el, j|
        color = (i + j).even? ? :cyan : :light_red
        color = :yellow if [i, j] == cursor
        unless self[cursor].empty?
          color = :light_green if self[cursor].moves.include?([i, j])
        end
        print " #{el.to_s} ".colorize(:background => color)
      end
      puts ""
    end
    nil
  end

  def in_check?(color)

  end

  def move(start, end_pos)

  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  # oringal case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  def respond_to_input
    c = read_char
    case c
    when "\r"
      puts "RETURN"
    when "\e[A"
      move_cursor([-1, 0])
    when "\e[B"
      move_cursor([1, 0])
    when "\e[C"
      move_cursor([0, 1])
    when "\e[D"
      move_cursor([0, -1])
    when "\u0003"
      raise Interrupt
    end
  end

end

b = Board.new
b.render
while true
  b.respond_to_input
end
