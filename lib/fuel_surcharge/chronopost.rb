# frozen_string_literal: true

require "fuel_surcharge/http_request"
require "fuel_surcharge/string_formatter"
require "fuel_surcharge/html_scanner"

module FuelSurcharge
  class Chronopost
    using StringFormatter

    def time_period
      periods[1]
    end

    def air_multiplier
      air_percentage&.to_multiplier
    end

    def road_multiplier
      road_percentage&.to_multiplier
    end

    def air_percentage
      @air_percentage ||= begin
         content = HTMLScanner.new(air_content).all("td")
         content[1]
      end
    end

    def road_percentage
      @road_percentage ||=begin
        content = HTMLScanner.new(road_content).all("td")
        content[1]
     end
    end

    def url
      "https://www.chronopost.fr/fr/surcharge-carburant"
    end

    private

    def periods
      @periods ||= HTMLScanner.new(thead).all("th").map { |e| e.to_s.strip_html.squish }
    end

    def air_content
      rows.select { |e| e.include?("Aérien") }
    end

    def road_content
      rows.select { |e| e.include?("Routier") }
    end

    def rows
      @rows ||= HTMLScanner.new(tbody).all("tr")
    end

    def thead
      @thead ||= HTMLScanner.new(table).upcoming("thead")
    end

    def tbody
      @tbody ||= HTMLScanner.new(table).upcoming("tbody")
    end

    def table
      @table ||= HTMLScanner.new(source_html).upcoming("table")
    end

    def source_html
      @source_html ||= HTTPRequest.new(url)
        .response
        .to_s
        .delete("\n")
        .gsub(/\s+/, " ")
    end
  end
end
