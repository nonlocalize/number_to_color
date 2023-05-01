# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/number_to_color"

# Test class for NumberToColor.
class NumberToColorTest < Minitest::Test
  def setup
    @max_end = "#0ea5e9"
    @max_start = "#f87171"
    @middle = "#ffffff"
    @middle_purple = "#838bad"
  end

  def test_middle_color
    assert_equal middle, ColorCode.new(value: 1, domain: [0, 1, 2]).hex_color
  end

  def test_end_color
    assert_equal max_end, ColorCode.new(value: 2, domain: [0, 1, 2]).hex_color
  end

  def test_start_color
    assert_equal max_start, ColorCode.new(value: 0, domain: [0, 1, 2]).hex_color
  end

  def test_middle_color_with_reverse_domain
    assert_equal middle, ColorCode.new(value: 1, domain: [2, 1, 0]).hex_color
  end

  def test_end_color_when_reversed_domain
    assert_equal max_end, ColorCode.new(value: 0, domain: [2, 1, 0]).hex_color
  end

  def test_start_color_with_reversed_domain
    assert_equal max_start, ColorCode.new(value: 2, domain: [2, 1, 0]).hex_color
  end

  def test_custom_middle_hex_color
    assert_equal "#000000", ColorCode.new(value: 1, domain: [0, 1, 2], middle_color: "#000000").hex_color
  end

  def test_custom_end_hex_color
    assert_equal "#000000", ColorCode.new(value: 2, domain: [0, 1, 2], end_color: "#000000").hex_color
  end

  def test_custom_start_hex_color
    assert_equal "#000000", ColorCode.new(value: 0, domain: [0, 1, 2], start_color: "#000000").hex_color
  end

  def test_custom_middle_rgb_color
    assert_equal "#16a34a", ColorCode.new(value: 1, domain: [0, 1, 2], middle_color: [22, 163, 74]).hex_color
  end

  def test_custom_end_rgb_color
    assert_equal "#16a34a", ColorCode.new(value: 2, domain: [0, 1, 2], end_color: [22, 163, 74]).hex_color
  end

  def test_custom_start_rgb_color
    assert_equal "#16a34a", ColorCode.new(value: 0, domain: [0, 1, 2], start_color: [22, 163, 74]).hex_color
  end

  def test_middle_color_with_non_linear_midpoint
    assert_equal middle, ColorCode.new(value: 2.5, domain: [0, 2.5, 3]).hex_color
  end

  def test_two_item_domain_with_custom_start_color
    assert_equal "#ffffff", ColorCode.new(value: 0, domain: [0, 1], start_color: "#ffffff").hex_color
  end

  def test_two_item_domain_end_color
    assert_equal max_end, ColorCode.new(value: 1, domain: [0, 1]).hex_color
  end

  def test_two_item_domain_middle_color
    assert_equal middle_purple, ColorCode.new(value: 0.5, domain: [0, 1]).hex_color
  end

  private

  attr_reader :max_end, :max_start, :middle, :middle_purple
end
