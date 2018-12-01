# frozen_string_literal: true

require "test_helper"

module FuelSurcharge
  class ChronopostTest < Minitest::Test
    def test_time_period
      nominal_case do
        assert_equal "Novembre 2018", @chronopost.time_period
      end

      failing_case do
        assert_nil @chronopost.time_period
      end
    end

    def test_air
      nominal_case do
        assert_equal "20,15%", @chronopost.air_percentage
        assert_equal 1.2015,   @chronopost.air_multiplier
      end

      failing_case do
        assert_nil @chronopost.air_percentage
        assert_nil @chronopost.air_multiplier
      end
    end

    def test_road
      nominal_case do
        assert_equal "14,80%", @chronopost.road_percentage
        assert_equal 1.1480,   @chronopost.road_multiplier
      end

      failing_case do
        assert_nil @chronopost.road_percentage
        assert_nil @chronopost.road_multiplier
      end
    end

    FRENCH_MONTHS = %w[janvier février mars avril mai juin juillet août
                       septembre octobre novembre décembre].freeze

    def test_live_values
      skip if ENV["SKIP_LIVE_TESTS"]

      @chronopost = Chronopost.new

      time_period   = @chronopost.time_period
      current_month = FRENCH_MONTHS[Date.today.month - 1]

      assert_kind_of String, time_period
      assert time_period.downcase.start_with?(current_month)
      assert time_period.end_with?(Date.today.year.to_s)

      assert_kind_of String,     @chronopost.air_percentage
      refute_empty               @chronopost.air_percentage
      assert_kind_of BigDecimal, @chronopost.air_multiplier
      assert_operator @chronopost.air_multiplier, :>=, 1.0

      assert_kind_of String,     @chronopost.road_percentage
      refute_empty               @chronopost.road_percentage
      assert_kind_of BigDecimal, @chronopost.road_multiplier
      assert_operator @chronopost.road_multiplier, :>=, 1.0
    end

    private

    def nominal_case
      response = File.read("test/fixtures/chronopost_sample_response.html")
      HTTPRequest.stub_any_instance :response, response do
        @chronopost = Chronopost.new
        yield
      end
    end

    def failing_case
      HTTPRequest.stub_any_instance :response, "" do
        @chronopost = Chronopost.new
        yield
      end
    end
  end
end
