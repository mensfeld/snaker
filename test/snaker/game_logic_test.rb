# frozen_string_literal: true

require 'test_helper'

module Snaker
  class GameLogicTest < Minitest::Test
    def test_normalize_board_size_with_small_value
      assert_equal 12, GameLogic.normalize_board_size(5)
      assert_equal 12, GameLogic.normalize_board_size(0)
      assert_equal 12, GameLogic.normalize_board_size(-1)
      assert_equal 12, GameLogic.normalize_board_size(12)
    end

    def test_normalize_board_size_with_large_value
      assert_equal 15, GameLogic.normalize_board_size(15)
      assert_equal 20, GameLogic.normalize_board_size(20)
      assert_equal 100, GameLogic.normalize_board_size(100)
    end

    def test_normalize_board_size_with_string
      assert_equal 12, GameLogic.normalize_board_size('5')
      assert_equal 15, GameLogic.normalize_board_size('15')
      assert_equal 12, GameLogic.normalize_board_size('')
    end

    def test_create_board_has_correct_dimensions
      board = GameLogic.create_board(12)

      assert_equal 14, board.size
      assert_equal 14, board.first.size
    end

    def test_create_board_has_borders
      board = GameLogic.create_board(12)

      # Top row is all borders
      assert(board[0].all?(GameLogic::BORDER))
      # Bottom row is all borders
      assert(board[13].all?(GameLogic::BORDER))
      # Left column is borders
      assert(board.all? { |row| row[0] == GameLogic::BORDER })
      # Right column is borders
      assert(board.all? { |row| row[13] == GameLogic::BORDER })
    end

    def test_create_board_has_empty_center
      board = GameLogic.create_board(12)

      # Center should be empty
      (1..12).each do |row|
        (1..12).each do |col|
          assert_equal GameLogic::EMPTY, board[row][col]
        end
      end
    end

    def test_initial_snake_position
      snake = GameLogic.initial_snake_position(12)

      assert_equal 3, snake.size
      assert_equal [[12, 1], [12, 2], [12, 3]], snake
    end

    def test_calculate_score_fast_collection
      # Quick collection (0 steps) at level 0
      assert_equal 100, GameLogic.calculate_score(0, 0)
    end

    def test_calculate_score_with_steps
      # 5 steps = 100 - 50 = 50 points
      assert_equal 50, GameLogic.calculate_score(5, 0)
    end

    def test_calculate_score_with_level_bonus
      # 0 steps at level 2.5 = 100 + 2.5 = 102
      assert_equal 102, GameLogic.calculate_score(0, 2.5)
    end

    def test_calculate_score_minimum_one
      # Very slow = still get 1 point minimum
      assert_equal 1, GameLogic.calculate_score(100, 0)
      assert_equal 1, GameLogic.calculate_score(50, 0)
    end

    def test_calculate_level
      assert_in_delta 0.0, GameLogic.calculate_level(3)
      assert_in_delta 1.0, GameLogic.calculate_level(13)
      assert_in_delta 2.0, GameLogic.calculate_level(23)
      assert_in_delta 0.5, GameLogic.calculate_level(8)
    end

    def test_calculate_speed
      assert_in_delta 0.30, GameLogic.calculate_speed(0)
      assert_in_delta 0.30, GameLogic.calculate_speed(5)
      # At level 10+, speed reduction kicks in (hits minimum)
      assert_in_delta 0.05, GameLogic.calculate_speed(10)
    end

    def test_calculate_speed_minimum
      # Speed should never go below minimum
      assert_operator GameLogic.calculate_speed(100), :>=, 0.05
    end

    def test_valid_gem_position_in_center
      board = GameLogic.create_board(12)

      assert GameLogic.valid_gem_position?(board, 5, 5, 12)
      assert GameLogic.valid_gem_position?(board, 1, 1, 12)
      assert GameLogic.valid_gem_position?(board, 12, 12, 12)
    end

    def test_valid_gem_position_on_border
      board = GameLogic.create_board(12)

      refute GameLogic.valid_gem_position?(board, 0, 0, 12)
      refute GameLogic.valid_gem_position?(board, 0, 5, 12)
      refute GameLogic.valid_gem_position?(board, 13, 13, 12)
    end

    def test_valid_gem_position_on_snake
      board = GameLogic.create_board(12)
      board[5][5] = GameLogic::BORDER # Snake segment

      refute GameLogic.valid_gem_position?(board, 5, 5, 12)
    end

    def test_find_gem_position_returns_valid_position
      board = GameLogic.create_board(12)

      10.times do
        row, col = GameLogic.find_gem_position(board, 12)

        assert row.between?(1, 12)
        assert col.between?(1, 12)
        assert_equal GameLogic::EMPTY, board[row][col]
      end
    end

    def test_next_head_position
      head = [5, 5]

      assert_equal [4, 5], GameLogic.next_head_position(head, :up)
      assert_equal [6, 5], GameLogic.next_head_position(head, :down)
      assert_equal [5, 6], GameLogic.next_head_position(head, :right)
      assert_equal [5, 4], GameLogic.next_head_position(head, :left)
    end

    def test_collision_with_border
      board = GameLogic.create_board(12)

      assert GameLogic.collision?(board, 0, 5)
      assert GameLogic.collision?(board, 13, 5)
      assert GameLogic.collision?(board, 5, 0)
      assert GameLogic.collision?(board, 5, 13)
    end

    def test_collision_with_empty
      board = GameLogic.create_board(12)

      refute GameLogic.collision?(board, 5, 5)
      refute GameLogic.collision?(board, 1, 1)
    end

    def test_collision_with_snake
      board = GameLogic.create_board(12)
      board[5][5] = GameLogic::BORDER

      assert GameLogic.collision?(board, 5, 5)
    end

    def test_parse_key_input
      assert_equal :up, GameLogic.parse_key_input('[A')
      assert_equal :down, GameLogic.parse_key_input('[B')
      assert_equal :right, GameLogic.parse_key_input('[C')
      assert_equal :left, GameLogic.parse_key_input('[D')
      assert_nil GameLogic.parse_key_input('xx')
    end

    def test_valid_direction_change_allowed
      assert GameLogic.valid_direction_change?(:up, :left)
      assert GameLogic.valid_direction_change?(:up, :right)
      assert GameLogic.valid_direction_change?(:left, :up)
      assert GameLogic.valid_direction_change?(:left, :down)
    end

    def test_valid_direction_change_reversing_not_allowed
      refute GameLogic.valid_direction_change?(:up, :down)
      refute GameLogic.valid_direction_change?(:down, :up)
      refute GameLogic.valid_direction_change?(:left, :right)
      refute GameLogic.valid_direction_change?(:right, :left)
    end

    def test_valid_direction_change_nil_current
      assert GameLogic.valid_direction_change?(nil, :up)
      assert GameLogic.valid_direction_change?(nil, :down)
    end

    def test_constants_defined
      refute_nil GameLogic::GEM
      refute_nil GameLogic::BORDER
      refute_nil GameLogic::EMPTY
      refute_nil GameLogic::DIRECTIONS
      refute_nil GameLogic::KEY_MAP
    end

    def test_directions_are_frozen
      assert_predicate GameLogic::DIRECTIONS, :frozen?
      assert_predicate GameLogic::KEY_MAP, :frozen?
    end
  end
end
