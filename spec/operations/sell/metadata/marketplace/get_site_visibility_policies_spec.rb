RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_site_visibility_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_site_visibility_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_site_visibility_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_site_visibility_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns site visibility policies" do
      expect(subject["siteVisibilityPolicies"]).to be_an(Array)
      expect(subject["siteVisibilityPolicies"].count).to eq(1)
    end

    describe "site visibility policy" do
      let(:policy) { subject["siteVisibilityPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["crossBorderTradeNorthAmericaEnabled"]).to eq(true)
        expect(policy["crossBorderTradeGBEnabled"]).to eq(false)
        expect(policy["crossBorderTradeAustraliaEnabled"]).to eq(false)
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for siteVisibilityPolicies" do
      expect(subject["siteVisibilityPolicies"]).to eq([])
    end
  end
end
