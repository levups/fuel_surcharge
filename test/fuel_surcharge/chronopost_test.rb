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

    def test_live_values
      skip if ENV["SKIP_LIVE_TESTS"]

      live_chronopost = Chronopost.new
      live_date = Date.parse live_chronopost.time_period

      assert_equal Date.today.month, live_date.month
      assert_equal Date.today.year,  live_date.year

      assert_kind_of String,     live_chronopost.air_percentage
      refute_empty               live_chronopost.air_percentage
      assert_kind_of BigDecimal, live_chronopost.air_multiplier
      assert_operator live_chronopost.air_multiplier, :>=, 1.0

      assert_kind_of String,     live_chronopost.road_percentage
      refute_empty               live_chronopost.road_percentage
      assert_kind_of BigDecimal, live_chronopost.road_multiplier
      assert_operator live_chronopost.road_multiplier, :>=, 1.0
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
