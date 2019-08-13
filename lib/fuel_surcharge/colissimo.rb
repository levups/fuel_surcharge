# frozen_string_literal: true

require "fuel_surcharge/http_request"
require "fuel_surcharge/string_formatter"

require "rexml/document"

# Expected XML is like:
#   <indice_gazole>
#     <cap>
#       <cap_mois>
#         <titre>05-2017</titre>
#         <routier>0,77%</routier>
#         <aerien>0,00%</aerien>
#       </cap_mois>
#       ...
#     </cap>
#   <indice_gazole>
module FuelSurcharge
  class Colissimo
    using StringFormatter

    def initialize
      @parsed_values = {}
      return unless xml_root

      caps = xml_root.elements.first
      month = caps.elements.first
      month.elements.each do |element|
        @parsed_values[element.name] = element.text
      end
    end

    def url
      "https://www.colissimo.entreprise.laposte.fr/fr/system/files/imagescontent/docs/indice_gazole.xml"
    end

    def time_period
      @parsed_values["titre"]
    end

    def air_percentage
      @parsed_values["aerien"]
    end

    def road_percentage
      @parsed_values["routier"]
    end

    def air_multiplier
      air_percentage&.to_multiplier
    end

    def road_multiplier
      road_percentage&.to_multiplier
    end

    private

    def xml_root
      doc = ::REXML::Document.new HTTPRequest.new(url).response.to_s
      doc.root
    end
  end
end
