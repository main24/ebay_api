#
# eBay Metadata API
# @see https://developer.ebay.com/api-docs/sell/metadata/overview.html
#
class EbayAPI
  scope :commerce do
    scope :metadata do
      path { "catalog/v#{EbayAPI::COMMERCE_METADATA_VERSION.split(/\s|\./).first}" }

      require_relative "metadata/marketplace"
    end
  end
end
