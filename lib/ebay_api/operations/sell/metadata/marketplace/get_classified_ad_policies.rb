# @see https://developer.ebay.com/api-docs/sell/metadata/resources/marketplace/methods/getClassifiedAdPolicies

class EbayAPI
  scope :sell do
    scope :metadata do
      scope :marketplace do
        operation :get_classified_ad_policies do
          path { "get_classified_ad_policies" }
          http_method :get

          # When no policies are available, eBay returns 204 No Content.
          # To provide a consistent API, we return an empty array instead.
          response(204) { { "classifiedAdPolicies" => [] } }
        end
      end
    end
  end
end

