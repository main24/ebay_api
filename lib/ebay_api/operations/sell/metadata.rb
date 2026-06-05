#
# eBay Metadata API
# @see https://developer.ebay.com/api-docs/sell/metadata/overview.html
#
class EbayAPI
  scope :sell do
    scope :metadata do
      path { "metadata/v#{EbayAPI::SELL_METADATA_VERSION.split(/\s|\./).first}" }

      require_relative "metadata/marketplace"
    end
  end
end
