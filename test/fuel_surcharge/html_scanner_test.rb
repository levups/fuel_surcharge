# frozen_string_literal: true

require "test_helper"

module FuelSurcharge
  class HTMLScannerTest < Minitest::Test
    def test_upcoming
      assert_equal "Plop", HTMLScanner.new(source_html).upcoming("title")
      assert_equal "Flat", HTMLScanner.new(source_html).upcoming("p")
      assert_equal "Hey",  HTMLScanner.new(source_html).upcoming("p", 'class="yop"')
      assert_nil           HTMLScanner.new(source_html).upcoming("p", 'class="toto"')

      head = HTMLScanner.new(source_html).upcoming("head")
      assert_equal "Plop", HTMLScanner.new(head).upcoming("title")
      assert_nil           HTMLScanner.new(head).upcoming("p")
    end

    def test_all
      assert_equal [],              HTMLScanner.new(source_html).all("div")
      assert_equal ["Flat", "Hey"], HTMLScanner.new(source_html).all("p")
      assert_equal ["Hey"],         HTMLScanner.new(source_html).all("p", 'class="yop"')
      assert_equal [],              HTMLScanner.new(source_html).all("p", 'class="toto"')
    end

    private

    def source_html
      "<html><head><title>Plop</title></head><body><h1>Yo!</h1><p>Flat</p><p class=\"yop\">Hey</p></body></html>"
    end
  end
end
