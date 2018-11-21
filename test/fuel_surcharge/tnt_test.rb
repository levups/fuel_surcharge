# frozen_string_literal: true

require "test_helper"

module FuelSurcharge
  class TnTTest < Minitest::Test
    def test_time_period
      nominal_case do
        assert_equal "novembre 2018", @tnt.time_period
      end

      failing_case do
        assert_nil @tnt.time_period
      end
    end

    def test_air
      nominal_case do
        assert_equal "18,50%", @tnt.air_percentage
        assert_equal 1.185,    @tnt.air_multiplier
      end

      failing_case do
        assert_nil @tnt.air_percentage
        assert_nil @tnt.air_multiplier
      end
    end

    def test_road
      nominal_case do
        assert_equal "12,10%", @tnt.road_percentage
        assert_equal 1.121,    @tnt.road_multiplier
      end

      failing_case do
        assert_nil @tnt.road_percentage
        assert_nil @tnt.road_multiplier
      end
    end

    def test_live_values
      live_tnt  = Tnt.new
      live_date = Date.parse live_tnt.time_period

      assert_equal Date.today.month, live_date.month
      assert_equal Date.today.year,  live_date.year

      assert_kind_of String,     live_tnt.air_percentage
      refute_empty               live_tnt.air_percentage
      assert_kind_of BigDecimal, live_tnt.air_multiplier
      assert_operator live_tnt.air_multiplier, :>=, 1.0

      assert_kind_of String,     live_tnt.road_percentage
      refute_empty               live_tnt.road_percentage
      assert_kind_of BigDecimal, live_tnt.road_multiplier
      assert_operator live_tnt.road_multiplier, :>=, 1.0
    end

    private

    def nominal_case
      sample_response = File.read("test/fixtures/tnt_sample_response.html")
      HTTPRequest.stub_any_instance :response, sample_response do
        @tnt = Tnt.new
        yield
      end
    end

    def failing_case
      HTTPRequest.stub_any_instance :response, "" do
        @tnt = Tnt.new
        yield
      end
    end
  end
end
