# frozen_string_literal: true

require "strscan"

module FuelSurcharge
  class HTMLScanner
    def initialize(source)
      @scanner = StringScanner.new(source.to_s)
    end

    def upcoming(tag, attribute = nil)
      return if @scanner.eos?

      opening = attribute ? "<#{tag}\s[^>]*#{attribute}[^>]*>" : "<#{tag}[^>]*>"
      closing = "</#{tag}>"
      return unless @scanner.exist?(/#{opening}/) && @scanner.exist?(/#{closing}/)

      current_pos = @scanner.pos
      @scanner.skip_until(/#{opening}/)
      chunk = @scanner.scan_until(/#{closing}/).to_s
      @scanner.pos = current_pos if chunk.empty?
      chunk[0...chunk.size - closing.size].strip
    end

    def all(tag, attribute = nil)
      chunks = []
      return chunks if @scanner.eos?

      while (chunk = upcoming(tag, attribute))
        chunks << chunk
      end
      chunks
    end
  end
end
