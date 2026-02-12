RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_shipping_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_shipping_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_shipping_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_shipping_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns shipping policies" do
      expect(subject["shippingPolicies"]).to be_an(Array)
      expect(subject["shippingPolicies"].count).to eq(1)
    end

    describe "shipping policy" do
      let(:policy) { subject["shippingPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["shippingTermsRequired"]).to eq(true)
        expect(policy["handlingTimeEnabled"]).to eq(true)
        expect(policy["globalShippingEnabled"]).to eq(true)
      end

      it "has max flat shipping cost with proper attributes" do
        max_cost = policy["maxFlatShippingCost"]
        expect(max_cost["value"]).to eq("20.0")
        expect(max_cost["currency"]).to eq("USD")
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for shippingPolicies" do
      expect(subject["shippingPolicies"]).to eq([])
    end
  end
end

