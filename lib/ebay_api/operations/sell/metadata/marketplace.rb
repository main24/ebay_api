class EbayAPI
  scope :sell do
    scope :metadata do
      scope :marketplace do
        path { "marketplace/#{marketplace_id}" }
        option :marketplace_id

        require_relative "marketplace/get_item_condition_policies"
        require_relative "marketplace/get_category_policies"
        require_relative "marketplace/get_classified_ad_policies"
        require_relative "marketplace/get_automotive_parts_compatibility_policies"
      end
    end
  end
end
