# frozen_string_literal: true

require "fuel_surcharge/http_request"
require "fuel_surcharge/string_formatter"

module FuelSurcharge
  class TNT
    using StringFormatter

    def initialize
      latest_road_values_position = 0
      latest_air_values_position = extracted_values.size.div(2)
      @road_values = extracted_values[latest_road_values_position]
      @air_values  = extracted_values[latest_air_values_position]
    end

    def url
      "https://www.tnt.com/express/fr_fr/site/home/comment-expedier/facturation/surcharges/baremes-et-historiques.html"
    end

    def time_period
      return unless @road_values

      @road_values.first.to_s.strip
    end

    def road_percentage
      return unless @road_values

      @road_values.last.to_s
    end

    def air_percentage
      return unless @air_values

      @air_values.last.to_s
    end

    def road_multiplier
      road_percentage&.to_multiplier
    end

    def air_multiplier
      air_percentage&.to_multiplier
    end

    private

    VALUES_REGEX = /Surcharge d[e\' ]+(.*) : (.*%)</.freeze
    # [
    #   [" novembre 2018 ",  "12,10%"],
    #   ["octobre 2018 ",    "11,95%"],
    #   [" septembre 2018 ", "11,95%"],
    #   [" novembre 2018 ",  "18,50%"],
    #   ["octobre 2018 ",    "17,50%"],
    #   [" septembre 2018 ", "17,50%"]
    # ]
    def extracted_values
      @extracted_values ||= response.to_s.scan(VALUES_REGEX)
    end

    def response
      @response ||= HTTPRequest.new(url).response
    end
  end
end
