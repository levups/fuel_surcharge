# frozen_string_literal: true

require "test_helper"
require "date"

module FuelSurcharge
  class ColissimoTest < Minitest::Test
    def test_time_period
      nominal_case do
        assert_equal "12-2018", @colissimo.time_period
      end

      failing_case do
        assert_nil @colissimo.time_period
      end
    end

    def test_air
      nominal_case do
        assert_equal "3,58%", @colissimo.air_percentage
        assert_equal 1.0358,  @colissimo.air_multiplier
      end

      failing_case do
        assert_nil @colissimo.air_percentage
        assert_nil @colissimo.air_multiplier
      end
    end

    def test_road
      nominal_case do
        assert_equal "2,24%", @colissimo.road_percentage
        assert_equal 1.0224,  @colissimo.road_multiplier
      end

      failing_case do
        assert_nil @colissimo.road_percentage
        assert_nil @colissimo.road_multiplier
      end
    end

    def test_live
      skip if ENV["SKIP_LIVE_TESTS"]

      @colissimo = Colissimo.new

      time_period   = @colissimo.time_period
      current_month = Date.today.month.to_s.rjust(2, "0")

      assert_kind_of String, time_period
      assert time_period.start_with?(current_month)
      assert time_period.end_with?(Date.today.year.to_s)

      assert_kind_of String,     @colissimo.air_percentage
      refute_empty               @colissimo.air_percentage
      assert_kind_of BigDecimal, @colissimo.air_multiplier
      assert_operator @colissimo.air_multiplier, :>=, 1.0

      assert_kind_of String,     @colissimo.road_percentage
      refute_empty               @colissimo.road_percentage
      assert_kind_of BigDecimal, @colissimo.road_multiplier
      assert_operator @colissimo.road_multiplier, :>=, 1.0
    end

    private

    def nominal_case
      sample_response = File.read("test/fixtures/colissimo_sample_response.xml")
      HTTPRequest.stub_any_instance :response, sample_response do
        @colissimo = Colissimo.new
        yield
      end
    end

    def failing_case
      HTTPRequest.stub_any_instance :response, "" do
        @colissimo = Colissimo.new
        yield
      end
    end
  end
end
