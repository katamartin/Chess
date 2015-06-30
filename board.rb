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
    return true if board[pos].empty?
    !same_color?(color, pos)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def same_color?(color, pos)
    board[pos].color == color
  end

  def move(pos)
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
        color = (i + j).even? ? :blue : :red
        color = :yellow if [i, j] == cursor
        print " #{el.to_s} ".colorize(:background => color)
      end
      puts ""
    end
    nil
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
  def show_single_key
    c = read_char

    case c
    when "\r"
      puts "RETURN"
    when "\e[A"
      move([-1, 0])
    when "\e[B"
      move([1, 0])
    when "\e[C"
      move([0, 1])
    when "\e[D"
      move([0, -1])
    end
  end

end
