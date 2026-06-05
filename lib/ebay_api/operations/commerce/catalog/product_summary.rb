require_relative "product_summary/search"

class EbayAPI
  scope :commerce do
    scope :catalog do
      scope :product_summary do
        path "product_summary"

        response(400, 409) do |_, _, (data, *)|
          code = data.dig("errors", 0, "errorId")
          message = data.dig("errors", 0, "message")
          case code
            when 35_060
              raise EbayAPI::UserActionRequired.new(code: code), message
            else
              super!
          end
        end
      end
    end
  end
end