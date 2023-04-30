# frozen_string_literal: true

require "minitest/autorun"
require_relative "../lib/number_to_color"

# Test class for NumberToColor.
class NumberToColorTest < Minitest::Test
  def setup
    @max_positive = "#0ea5e9"
    @max_negative = "#f87171"
    @neutral = "#ffffff"
  end

  def test_neutral_color
    assert_equal neutral, ColorCode.new(value: 1, domain: [0, 2]).hex_color
  end

  def test_positive_color
    assert_equal max_positive, ColorCode.new(value: 2, domain: [0, 2]).hex_color
  end

  def test_negative_color
    assert_equal max_negative, ColorCode.new(value: 0, domain: [0, 2]).hex_color
  end

  def test_neutral_color_with_reverse_domain
    assert_equal neutral, ColorCode.new(value: 1, domain: [2, 0]).hex_color
  end

  def test_positive_color_when_reversed_domain
    assert_equal max_positive, ColorCode.new(value: 0, domain: [2, 0]).hex_color
  end

  def test_negative_color_with_reversed_domain
    assert_equal max_negative, ColorCode.new(value: 2, domain: [2, 0]).hex_color
  end

  def test_neutral_color_with_linear_midpoint
    assert_equal neutral, ColorCode.new(value: 2, domain: [0, 2, 4]).hex_color
  end

  def test_positive_color_with_linear_midpoint
    assert_equal max_positive, ColorCode.new(value: 4, domain: [0, 2, 4]).hex_color
  end

  def test_negative_color_with_linear_midpoint
    assert_equal max_negative, ColorCode.new(value: 0, domain: [0, 2, 4]).hex_color
  end

  def test_custom_neutral_hex_color
    assert_equal "#000000", ColorCode.new(value: 1, domain: [0, 2], neutral_color: "#000000").hex_color
  end

  def test_custom_positive_hex_color
    assert_equal "#000000", ColorCode.new(value: 2, domain: [0, 2], positive_color: "#000000").hex_color
  end

  def test_custom_negative_hex_color
    assert_equal "#000000", ColorCode.new(value: 0, domain: [0, 2], negative_color: "#000000").hex_color
  end

  def test_custom_neutral_rgb_color
    assert_equal "#16a34a", ColorCode.new(value: 1, domain: [0, 2], neutral_color: [22, 163, 74]).hex_color
  end

  def test_custom_positive_rgb_color
    assert_equal "#16a34a", ColorCode.new(value: 2, domain: [0, 2], positive_color: [22, 163, 74]).hex_color
  end

  def test_custom_negative_rgb_color
    assert_equal "#16a34a", ColorCode.new(value: 0, domain: [0, 2], negative_color: [22, 163, 74]).hex_color
  end

  def test_neutral_color_with_non_linear_midpoint
    assert_equal neutral, ColorCode.new(value: 2.5, domain: [0, 2.5, 3]).hex_color
  end

  private

  attr_reader :max_positive, :max_negative, :neutral
end
