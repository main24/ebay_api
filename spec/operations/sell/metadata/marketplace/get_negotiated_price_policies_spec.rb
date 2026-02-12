RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_negotiated_price_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_negotiated_price_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_negotiated_price_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_negotiated_price_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns negotiated price policies" do
      expect(subject["negotiatedPricePolicies"]).to be_an(Array)
      expect(subject["negotiatedPricePolicies"].count).to eq(1)
    end

    describe "negotiated price policy" do
      let(:policy) { subject["negotiatedPricePolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["bestOfferAutoAcceptEnabled"]).to eq(true)
        expect(policy["bestOfferAutoDeclineEnabled"]).to eq(true)
        expect(policy["bestOfferCounterEnabled"]).to eq(true)
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for negotiatedPricePolicies" do
      expect(subject["negotiatedPricePolicies"]).to eq([])
    end
  end
end

