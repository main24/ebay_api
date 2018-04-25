class EbayAPI
  scope :commerce do
    scope :catalog do
      scope :product_summary do
        # @see https://developer.ebay.com/api-docs/commerce/catalog/resources/product_summary/methods/search
        operation :search do
          http_method :get
          path { :search }

          query do
            {
              q: keywords,
              gtin: gtin,
              mpn: mpn,
              category_ids: category_ids,
              limit: limit,
              offset: offset
            }.compact
          end

          option :keywords, optional: true
          option :gtin, optional: true
          option :mpn, optional: true
          option :category_ids, optional: true
          option :offset, optional: true
          option :limit, default: proc { 20 }, optional: true

          response(200) { |_, _, (data, *)| data }
          response(204) { {} }
          response(404) { {} }
        end
      end
    end
  end
end
