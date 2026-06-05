# @see https://developer.ebay.com/api-docs/sell/metadata/resources/marketplace/methods/getItemConditionPolicies

class EbayAPI
  scope :sell do
    scope :metadata do
      scope :marketplace do
        operation :get_item_condition_policies do
          path { "get_item_condition_policies" }
          http_method :get

          # When no policies are available, eBay returns 204 No Content.
          # To provide a consistent API, we return an empty array instead.
          response(204) { { "itemConditionPolicies" => [] } }
        end
      end
    end
  end
end
