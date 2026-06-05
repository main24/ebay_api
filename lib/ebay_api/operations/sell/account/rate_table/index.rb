class EbayAPI
  scope :sell do
    scope :account do
      scope :rate_table do
        # @see https://developer.ebay.com/api-docs/sell/account/resources/rate_table/methods/getRateTables
        operation :index do
          option :site, Site

          path  { "/" }
          query { { marketplace_id: site.key } }
          http_method :get
        end
      end
    end
  end
end
