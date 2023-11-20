class EbayAPI
  scope :developer do
    scope :analytics do
      scope :rate_limit do
        # @see https://developer.ebay.com/api-docs/developer/analytics/resources/rate_limit/methods/getRateLimits
        operation :get do
          option :api_context, optional: true
          option :api_name, optional: true

          http_method :get
          query do
            { api_context: api_context, api_name: api_name }.compact
          end

          response(200) do |_, _, (data, *)|
            data["rateLimits"]
          end
        end
      end
    end
  end
end
