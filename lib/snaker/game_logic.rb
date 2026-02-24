# frozen_string_literal: true

module Snaker
  # Extracted game logic for testing
  # The main game in snaker.rb is code-golfed for fun
  module GameLogic
    # ANSI color codes and symbols
    GEM = "\e[31m\u25C6\e[0m\e[32m "
    BORDER = "\u25FC "
    EMPTY = "\u25CB "

    # Direction vectors for arrow keys
    DIRECTIONS = {
      up: [-1, 0],
      down: [1, 0],
      right: [0, 1],
      left: [0, -1]
    }.freeze

    # Key escape sequences to direction mapping
    KEY_MAP = {
      '[A' => :up,
      '[B' => :down,
      '[C' => :right,
      '[D' => :left
    }.freeze

    module_function

    # Validates and normalizes board size (minimum 12)
    def normalize_board_size(size)
      size = size.to_i
      [size, 12].max
    end

    # Creates an empty game board with borders
    def create_board(size)
      range = 0...(size + 2)

      range.map do |row|
        range.map do |col|
          if row.between?(1, size) && col.between?(1, size)
            EMPTY
          else
            BORDER
          end
        end
      end
    end

    # Initializes snake at starting position (bottom-left, 3 segments)
    def initial_snake_position(board_size)
      [[board_size, 1], [board_size, 2], [board_size, 3]]
    end

    # Calculates score for collecting a gem
    # @param steps [Integer] steps taken since last gem
    # @param level [Float] current level
    # @return [Integer] points earned
    def calculate_score(steps, level)
      base = 100 - (steps * 10)
      base = 1 if base < 1
      (base + level).to_i
    end

    # Calculates current level based on snake size
    def calculate_level(snake_size)
      (snake_size - 3) / 10.0
    end

    # Calculates game speed (sleep duration) based on level
    def calculate_speed(level)
      base_speed = 0.30
      speed_reduction = (level / 10.0).floor
      [base_speed - speed_reduction, 0.05].max
    end

    # Checks if a position is valid for gem placement
    def valid_gem_position?(board, row, col, board_size)
      return false unless row.between?(1, board_size)
      return false unless col.between?(1, board_size)

      board[row][col] != BORDER
    end

    # Finds a random valid position for a gem
    def find_gem_position(board, board_size)
      loop do
        row = rand(1..board_size)
        col = rand(1..board_size)
        return [row, col] if valid_gem_position?(board, row, col, board_size)
      end
    end

    # Gets the next head position based on current position and direction
    def next_head_position(current_head, direction)
      delta = DIRECTIONS[direction]
      [current_head[0] + delta[0], current_head[1] + delta[1]]
    end

    # Checks if the next position would cause a collision
    def collision?(board, row, col)
      board[row][col] == BORDER
    end

    # Parses arrow key input to direction symbol
    def parse_key_input(key_sequence)
      KEY_MAP[key_sequence]
    end

    # Checks if direction change is valid (not reversing)
    def valid_direction_change?(current, new_direction)
      return true if current.nil?

      current_delta = DIRECTIONS[current]
      new_delta = DIRECTIONS[new_direction]

      # Can't reverse direction (sum of deltas would be [0, 0])
      (current_delta[0] + new_delta[0]) != 0 || (current_delta[1] + new_delta[1]) != 0
    end
  end
end
