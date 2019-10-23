# frozen_string_literal: true

require "test_helper"

module FuelSurcharge
  class TNTTest < Minitest::Test
    def test_time_period
      nominal_case(:html) do
        assert_equal "juillet 2019", @tnt.time_period
      end

      failing_case do
        assert_nil @tnt.time_period
      end
    end

    def test_air
      nominal_case(:json) do
        assert_equal "17,00%", @tnt.air_percentage
        assert_equal 1.170, @tnt.air_multiplier
      end

      failing_case do
        assert_nil @tnt.air_percentage
        assert_nil @tnt.air_multiplier
      end
    end

    def test_road
      nominal_case(:html) do
        assert_equal "12,10%", @tnt.road_percentage
        assert_equal 1.121, @tnt.road_multiplier
      end

      failing_case do
        assert_nil @tnt.road_percentage
        assert_nil @tnt.road_multiplier
      end
    end

    def test_live_values
      skip if ENV["SKIP_LIVE_TESTS"]

      @tnt = TNT.new

      time_period = @tnt.time_period
      previous_month = FuelSurcharge::TNT::FRENCH_MONTHS_NAMES[Date.today.month - 2]
      current_month = FuelSurcharge::TNT::FRENCH_MONTHS_NAMES[Date.today.month - 1]
      next_month = FuelSurcharge::TNT::FRENCH_MONTHS_NAMES[Date.today.month]

      assert_kind_of String, time_period
      assert time_period.downcase.start_with?(previous_month, current_month, next_month), time_period
      assert time_period.end_with?(Date.today.year.to_s)

      assert_kind_of String, @tnt.air_percentage
      refute_empty @tnt.air_percentage
      assert_kind_of BigDecimal, @tnt.air_multiplier
      assert_operator @tnt.air_multiplier, :>=, 1.0

      assert_kind_of String, @tnt.road_percentage
      refute_empty @tnt.road_percentage
      assert_kind_of BigDecimal, @tnt.road_multiplier
      assert_operator @tnt.road_multiplier, :>=, 1.0
    end

    private

    def nominal_case(kind)
      sample_response = File.read("test/fixtures/tnt_sample_response.#{kind}")
      HTTPRequest.stub_any_instance :response, sample_response do
        @tnt = TNT.new
        yield
      end
    end

    def failing_case
      HTTPRequest.stub_any_instance :response, "" do
        @tnt = TNT.new
        yield
      end
    end
  end
end
