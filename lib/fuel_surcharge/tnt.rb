# frozen_string_literal: true

require "fuel_surcharge/http_request"
require "fuel_surcharge/string_formatter"

module FuelSurcharge
  class TNT
    using StringFormatter

    def time_period
      road_value&.first&.to_s
    end

    def road_percentage
      road_value&.last&.to_s
    end

    def air_percentage
      if (value = air_value&.dig("list", 0, "surcharge"))
        value.tr(".", ",") << "%"
      end
    end

    def road_multiplier
      road_percentage&.to_multiplier
    end

    def air_multiplier
      air_percentage&.to_multiplier
    end

    def url
      "https://www.tnt.com/express/fr_fr/site/comment/facturation/comprendre-votre-facture/baremes-et-historiques.html"
    end

    private

    def json_air_url
      "https://www.tnt.com/express/getDynamicData.europe.json"
    end

    def air_value
      return if (json = air_response.to_s).empty?

      JSON.parse(json)
    end

    ROAD_VALUES_REGEX = /Surcharge d[e\' ]+ (\w+ \d{4}) : (.+%)</.freeze
    def road_value
      road_response.to_s.scan(ROAD_VALUES_REGEX).first
    end

    def road_response
      @response ||= HTTPRequest.new(url).response
    end

    def air_response
      @air_response ||= HTTPRequest.new(json_air_url).response
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
