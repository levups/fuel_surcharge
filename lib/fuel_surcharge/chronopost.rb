# frozen_string_literal: true

require "fuel_surcharge/http_request"
require "fuel_surcharge/string_formatter"

module FuelSurcharge
  class Chronopost
    using StringFormatter

    def initialize
      extract_content
    end

    attr_reader :time_period, :air_percentage, :road_percentage

    def air_multiplier
      air_percentage&.to_multiplier
    end

    def road_multiplier
      road_percentage&.to_multiplier
    end

    def url
      "https://www.chronopost.fr/fr/surcharge-carburant"
    end

    private

    def source_html
      HTTPRequest.new(url)
                 .response
                 .to_s
                 .delete("\n")
                 .gsub(/\s+/, " ")
    end

    def tables
      return unless source_html

      source_html.split("<table ")[1]
    end

    def table
      return unless tables

      tables.split("<h2>Principe</h2>").first
    end

    def head
      return unless table

      table.scan(%r{<thead>.*</thead>}).first
    end

    def period
      return unless head

      text = head.split(%r{</th>\s*<th}).last
      text.match(%r{<p>(?<content>.*)</p>})
    end

    def body
      return unless table

      table.scan(%r{<tbody><tr>.*</tr></tbody>}).first
    end

    def extract_content
      return unless period
      return unless body

      @time_period = period[:content].sub(%r{<br\s*/>}, "")
      @road_percentage, @air_percentage = body.split(%r{</tr>\s*<tr}).map do |line|
        line.to_s.rpartition("</td>").first.rpartition(">").last
      end
    end
  end
end
