# @see https://developer.ebay.com/api-docs/sell/metadata/resources/marketplace/methods/getItemConditionPolicies

class EbayAPI
  scope :sell do
    scope :metadata do
      scope :marketplace do
        operation :get_item_condition_policies do
          path { "get_item_condition_policies" }
          http_method :get
        end
      end
    end
  end
end
