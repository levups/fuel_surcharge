# frozen_string_literal: true

require "bigdecimal"

module FuelSurcharge
  module StringFormatter
    refine String do
      def to_multiplier
        clean_string = tr(",", ".").gsub(/[^0-9\.]/, "")
        number = BigDecimal(clean_string)
        1 + (number / 100).round(4)
      end

      # https://gist.github.com/awesome/225181
      def strip_html
        gsub(/<\/?[^>]*>/, "")
      end

      # From ActiveSupport
      def squish
        gsub!(/[[:space:]]+/, " ")
        strip!
        self
      end
    end
  end
end
