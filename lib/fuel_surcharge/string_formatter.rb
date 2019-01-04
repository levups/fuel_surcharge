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
    end
  end
end
