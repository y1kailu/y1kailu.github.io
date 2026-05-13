# frozen_string_literal: true

return unless Gem.win_platform?

require "jekyll/commands/serve/servlet"

module Jekyll
  module Commands
    class Serve
      class Servlet
        private

        # Jekyll 3.x can receive a nil MimeTypesCharset table on modern
        # Windows/Ruby setups. Skipping the charset injection keeps local
        # preview working and does not affect the generated site output.
        def conditionally_inject_charset(res)
          typ = res.header["content-type"]
          return unless typ
          return unless @mime_types_charset.respond_to?(:key?)
          return unless @mime_types_charset.key?(typ)
          return if %r!;\s*charset=!.match?(typ)

          res.header["content-type"] = "#{typ}; charset=#{@jekyll_opts["encoding"]}"
        end
      end
    end
  end
end
