# frozen_string_literal: true

require "test_helper"
require "date"

module FuelSurcharge
  class ColissimoTest < Minitest::Test
    def test_time_period
      nominal_case do
        assert_equal '11-2018', @colissimo.time_period
      end

      failing_case do
        assert_nil @colissimo.time_period
      end
    end

    def test_air
      nominal_case do
        assert_equal "3,01%", @colissimo.air_percentage
        assert_equal 1.0301,  @colissimo.air_multiplier
      end

      failing_case do
        assert_nil @colissimo.air_percentage
        assert_nil @colissimo.air_multiplier
      end
    end

    def test_road
      nominal_case do
        assert_equal "1,97%", @colissimo.road_percentage
        assert_equal 1.0197,  @colissimo.road_multiplier
      end

      failing_case do
        assert_nil @colissimo.road_percentage
        assert_nil @colissimo.road_multiplier
      end
    end

    def test_live
      live_colissimo = Colissimo.new
      live_date = Date.parse live_colissimo.time_period

      assert_equal Date.today.month, live_date.month
      assert_equal Date.today.year,  live_date.year

      assert_kind_of String,     live_colissimo.air_percentage
      refute_empty               live_colissimo.air_percentage
      assert_kind_of BigDecimal, live_colissimo.air_multiplier
      assert_operator live_colissimo.air_multiplier, :>=, 1.0

      assert_kind_of String,     live_colissimo.road_percentage
      refute_empty               live_colissimo.road_percentage
      assert_kind_of BigDecimal, live_colissimo.road_multiplier
      assert_operator live_colissimo.road_multiplier, :>=, 1.0
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
