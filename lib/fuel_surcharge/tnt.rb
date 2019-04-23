# frozen_string_literal: true

require "fuel_surcharge/http_request"
require "fuel_surcharge/string_formatter"

module FuelSurcharge
  class TNT
    using StringFormatter

    attr_accessor :current_month

    def initialize(current_month: Date.today.month)
      @current_month = current_month
    end

    def time_period
      road_value&.first&.to_s
    end

    def road_percentage
      road_value&.last&.to_s
    end

    def air_percentage
      air_value&.last&.to_s
    end

    def road_multiplier
      road_percentage&.to_multiplier
    end

    def air_multiplier
      air_percentage&.to_multiplier
    end

    private

    VALUES_REGEX = /Surcharge d[e\' ]+(.*) : (.*%)</.freeze
    # Sample obtained structure :
    # [
    #   [" novembre 2018 ",  "12,10%"],
    #   ["octobre 2018 ",    "11,95%"],
    #   [" septembre 2018 ", "11,95%"],
    #   [" novembre 2018 ",  "18,50%"],
    #   ["octobre 2018 ",    "17,50%"],
    #   [" septembre 2018 ", "17,50%"]
    # ]
    def extracted_values
      response.to_s.scan(VALUES_REGEX)
    end

    def current_month_values
      extracted_values.select { |month, value| month.include? current_month_name }
    end

    def air_value
      current_month_values.last
    end

    def road_value
      current_month_values.first
    end

    URL = "https://www.tnt.com/express/fr_fr/site/home/comment-expedier/facturation/surcharges/baremes-et-historiques.html"
    def response
      @response ||= HTTPRequest.new(URL).response
    end

    FRENCH_MONTHS_NAMES = %w[
      janvier
      février
      mars
      avril
      mai
      juin
      juillet
      août
      septembre
      octobre
      novembre
      décembre
    ].freeze

    def current_month_name
      FRENCH_MONTHS_NAMES[current_month - 1]
    end
  end
end
