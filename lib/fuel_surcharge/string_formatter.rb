# frozen_string_literal: true

require "bigdecimal"

module FuelSurcharge
  module StringFormatter
    refine String do
      def to_multiplier
        number = BigDecimal tr(",", ".").gsub(/[^0-9\.]/, "")

        (number / 100 + 1).round(4)
      end
    end
  end
end
