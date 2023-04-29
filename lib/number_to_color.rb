# frozen_string_literal: true

require_relative "number_to_color/version"

# Class to generate a hex color code based on a value and domain.
#
# @author Luke Fair <lfair@raysbaseball.com>
class ColorCode
  # '#0ea5e9'
  DEFAULT_POSITIVE = [14, 165, 233].freeze
  # 'f87171'
  DEFAULT_NEGATIVE = [248, 113, 113].freeze
  # 'fff'
  DEFAULT_NEUTRAL = [255, 255, 255].freeze

  # @param [Number] value The table cell's numerical value
  # @param [Array] domain - Two or three-element arrays (e.g., [0, 20], [-20, 0, 20])
  # @param [String] neutral_hex - The hex code to use for the neutral color.
  # @param [String] positive_hex - The hex code to use for the positive color.
  # @param [String] negative_hex - The hex code to use for the negative color.
  def initialize(
    value:,
    domain: nil,
    neutral_hex: nil,
    positive_hex: nil,
    negative_hex: nil
  )
    @value = value.to_f
    @domain = domain
    @neutral_hex = neutral_hex
    @negative_hex = negative_hex
    @positive_hex = positive_hex

    set_colors
  end

  # The public method to return the hex code.
  # @return [String].
  def hex_color
    rgb_to_hex(red: final_rgb[:r], green: final_rgb[:g], blue: final_rgb[:b])
  end

  private

  attr_reader :value, :domain, :positive_hex, :negative_hex, :neutral_hex, :positive_rgb, :negative_rgb, :neutral_rgb

  def set_colors
    @positive_rgb = positive_hex ? hex_to_rgb(positive_hex) : DEFAULT_POSITIVE
    @negative_rgb = negative_hex ? hex_to_rgb(negative_hex) : DEFAULT_NEGATIVE
    @neutral_rgb = neutral_hex ? hex_to_rgb(neutral_hex) : DEFAULT_NEUTRAL
  end

  # Returns the hex code for any RGB color.
  # @return [String].
  def rgb_to_hex(red:, green:, blue:)
    "##{Kernel.format("%02x%02x%02x", red, green, blue)}"
  end

  # Returns the hex code for any RGB color.
  # @param [String] hex The hex code to convert.
  # @return [Array].
  def hex_to_rgb(hex)
    hex.scan(/.{2}/).map(&:hex)
  end

  # If the domain is inverted, switch its order.
  # @return [Array].
  def normalized_domain
    return domain.reverse if inverted_order?

    domain
  end

  # Calcluate the final RGB value.
  # @return [Hash].
  def final_rgb
    r_start, g_start, b_start = start_color

    r_end, g_end, b_end = end_color

    {
      r: calculate_rgb_level(r_start, r_end),
      g: calculate_rgb_level(g_start, g_end),
      b: calculate_rgb_level(b_start, b_end)
    }
  end

  # Returns if the domain is reversed (lower number = good).
  # @return [Boolean].
  def inverted_order?
    domain.first > domain.last
  end

  # Calculate the specific level (R, G, or B) based on the start and end value.
  # @return [Integer].
  def calculate_rgb_level(start_level, end_level)
    r = ((end_level * distance_from_min_value) + (start_level * distance_difference)).to_i

    [[0, r].max, 255].min
  end

  # Clamp the value if it falls above or below the min.
  # @return [Number].
  def clamped_value
    return normalized_domain.first if value < normalized_domain.first

    return normalized_domain.last if value > normalized_domain.last

    value
  end

  # Returns the start color in RGB format.
  # @return [Array].
  def start_color
    return positive_rgb if inverted_order? && value_is_negative?

    return negative_rgb if value_is_negative?

    neutral_rgb
  end

  # Returns the end color in RGB format.
  # @return [Array].
  def end_color
    return neutral_rgb if value_is_negative?

    return negative_rgb if inverted_order?

    positive_rgb
  end

  # Returns if the value is considered negative.
  # @return [Boolean].
  def value_is_negative?
    clamped_value.between?(normalized_domain.first, mean_value) || clamped_value == mean_value
  end

  # Returns the domain's min value, or what is considered 'negative'.
  # @return [Number].
  def min_value
    return mean_value unless value_is_negative?

    normalized_domain.first
  end

  # Returns the domain's min value, or what is considered 'negative'.
  # @return [Number].
  def max_value
    return mean_value if value_is_negative?

    normalized_domain.last
  end

  # Returns the range's mean. This will be the median of a two-value domain,
  # or the middle value of a three-value domain.
  # @return [Number].
  def mean_value
    return normalized_domain[1] if normalized_domain.length == 3

    normalized_domain.sum(0.0) / normalized_domain.size
  end

  # Normalize the range in positive values [0, a_positive_value].
  # @return [Number].
  def normalized_max_value
    max_value - min_value
  end

  # Normalize the range in positive values [0, a_positive_value].
  # This ensures the value is positive.
  # @return [Number].
  def normalized_value
    clamped_value - min_value
  end

  # Normalize the range in positive values [0, a_positive_value].
  # @return [Number].
  def normalized_min_value
    0
  end

  # Calculate distance to min value on a 0,1 scale.
  # @return [Number].
  def distance_from_min_value
    normalized_value / normalized_max_value
  end

  def distance_difference
    1 - distance_from_min_value
  end
end
