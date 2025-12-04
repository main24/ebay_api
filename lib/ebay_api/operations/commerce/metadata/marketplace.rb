class EbayAPI
  scope :commerce do
    scope :metadata do
      scope :marketplace do
        path { "marketplace/#{marketplace_id}" }
        option :marketplace_id

        require_relative "marketplace/get_item_condition_policies"
      end
    end
  end
end
