class EbayAPI
  scope :sell do
    scope :account do
      scope :rate_table do
        path { "rate_table" }
      end
    end
  end
end

require_relative "rate_table/index"