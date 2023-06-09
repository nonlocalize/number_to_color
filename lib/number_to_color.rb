# frozen_string_literal: true

require_relative "number_to_color/version"

# Class to generate a hex color code based on a value and domain.
#
# @author Luke Fair <fair@hey.com>
class ColorCode
  # @param [Number] value The table cell's numerical value
  # @param [Array] domain - Two or three-element arrays (e.g., [0, 20], [-20, 0, 20])
  # @param [String|Array] middle_color - The hex or rgb code to use for the middle color (default `white`).
  # @param [String|Array] end_color - The hex or rgb code to use for the end color (default `blue`).
  # @param [String|Array] start_color - The hex or rgb code to use for the start color  (default `red`).
  def initialize(
    value:,
    domain: nil,
    middle_color: [255, 255, 255],
    end_color: [14, 165, 233],
    start_color: [248, 113, 113]
  )
    @value = value.to_f
    @domain = domain
    @middle_color = middle_color
    @start_color = start_color
    @end_color = end_color

    set_colors
  end

  # The public method to return the hex code.
  # @return [String].
  def hex_color
    rgb_to_hex(red: final_rgb[:r], green: final_rgb[:g], blue: final_rgb[:b])
  end

  private

  attr_reader :value, :domain, :end_color, :start_color, :middle_color, :end_rgb, :start_rgb,
              :middle_rgb

  def set_colors
    @end_rgb = format_color(end_color)
    @start_rgb = format_color(start_color)
    @middle_rgb = format_color(middle_color)
  end

  # Returns the hex code for any RGB color.
  # @return [String].
  def rgb_to_hex(red:, green:, blue:)
    "##{Kernel.format("%02x%02x%02x", red, green, blue)}"
  end

  # Returns the hex code for any RGB color.
  # @param [String|Array] color The hex or rgb code.
  # @return [Array].
  def format_color(color)
    return color.gsub("#", "").scan(/../).map(&:hex) if color.instance_of? String

    color unless color.nil?
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
    r_start, g_start, b_start = start_color_rgb

    r_end, g_end, b_end = end_color_rgb

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
  def start_color_rgb
    return end_rgb if inverted_order? && (value_is_in_starting_half? || two_item_domain?)

    return start_rgb if value_is_in_starting_half? || two_item_domain?

    middle_rgb
  end

  # Returns the end color in RGB format.
  # @return [Array].
  def end_color_rgb
    return middle_rgb if value_is_in_starting_half? && three_item_domain?

    return start_rgb if inverted_order?

    end_rgb
  end

  # Returns if the value is considered in the first half of the domain.
  # @return [Boolean].
  def value_is_in_starting_half?
    three_item_domain? && (clamped_value.between?(normalized_domain.first, mean_value) || clamped_value == mean_value)
  end

  # Returns the domain's min value.
  # @return [Number].
  def min_value
    return mean_value unless value_is_in_starting_half? || two_item_domain?

    normalized_domain.first
  end

  # Returns the domain's max value.
  # @return [Number].
  def max_value
    return mean_value if value_is_in_starting_half? && three_item_domain?

    normalized_domain.last
  end

  # Returns the range's mean. This will be the median of a two-value domain,
  # or the middle value of a three-value domain.
  # @return [Number].
  def mean_value
    return normalized_domain[1] if normalized_domain.length == 3

    normalized_domain.sum(0.0) / normalized_domain.size
  end

  # Normalize the range in end values [0, a_end_value].
  # @return [Number].
  def normalized_max_value
    max_value - min_value
  end

  # Normalize the range in end values [0, a_end_value].
  # This ensures the value is end.
  # @return [Number].
  def normalized_value
    clamped_value - min_value
  end

  # Calculate distance to min value on a 0,1 scale.
  # @return [Number].
  def distance_from_min_value
    normalized_value / normalized_max_value
  end

  def distance_difference
    1 - distance_from_min_value
  end

  # Returns if the domain has two values.
  # @return [Boolean].
  def two_item_domain?
    domain.length == 2
  end

  # Returns if the domain has three values.
  # @return [Boolean].
  def three_item_domain?
    domain.length == 3
  end
end
