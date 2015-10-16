module Finicity
  module Logger
    def log_request
      ::Finicity.logger.debug do
        log = "REQUEST: #{self.class.name}"
        log << "\n  URL: #{url}" if self.respond_to?(:url)
        log << "\n  QUERY: #{query}" if self.respond_to?(:query)
        log << "\n  BODY: #{mask_body(body)}" if self.respond_to?(:body)
        log
      end
    end

    def mask_body(body)
      body = body.gsub(/<value>.*<\/value>/, "<value>[FILTERED]</value>")
      body = body.gsub(/<answer>.*<\/answer>/, "<answer>[FILTERED]</answer>")
      body
    end
  end
end
