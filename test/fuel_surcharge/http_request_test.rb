# frozen_string_literal: true

require "test_helper"

module FuelSurcharge
  class HTTPRequestTest < Minitest::Test
    def test_http_error
      stubbed_response = proc { raise ::HTTP::Error }

      ::HTTP::Client.stub_any_instance(:get, stubbed_response) do
        http_request = HTTPRequest.new("http::/example.com")
        assert_equal "", http_request.response
      end
    end
  end
end
