# @see https://developer.ebay.com/api-docs/sell/metadata/resources/marketplace/methods/getNegotiatedPricePolicies

class EbayAPI
  scope :sell do
    scope :metadata do
      scope :marketplace do
        operation :get_negotiated_price_policies do
          path { "get_negotiated_price_policies" }
          http_method :get

          # When no policies are available, eBay returns 204 No Content.
          # To provide a consistent API, we return an empty array instead.
          response(204) { { "negotiatedPricePolicies" => [] } }
        end
      end
    end
  end
end
