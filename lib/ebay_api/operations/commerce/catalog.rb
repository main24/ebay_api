#
# Commerce Catalog API
#
class EbayAPI
  scope :commerce do
    scope :catalog do
      path { "catalog/v#{EbayAPI::COMMERCE_CATALOG_VERSION.split(/\s|\./).first}" }

      require_relative "catalog/product_summary"
    end
  end
end
