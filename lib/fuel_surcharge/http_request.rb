# frozen_string_literal: true

require "http"

module FuelSurcharge
  class HTTPRequest
    def initialize(url)
      @url = url
    end

    def response
      ::HTTP.timeout(10).get(@url)
    rescue HTTP::Error
      ''
    end
  end
end
