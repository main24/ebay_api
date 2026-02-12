RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_motors_listing_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_MOTORS_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_MOTORS_US/get_motors_listing_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_motors_listing_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_motors_listing_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns motors listing policies" do
      expect(subject["motorsListingPolicies"]).to be_an(Array)
      expect(subject["motorsListingPolicies"].count).to eq(1)
    end

    describe "motors listing policy" do
      let(:policy) { subject["motorsListingPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("6028")
        expect(policy["categoryTreeId"]).to eq("100")
        expect(policy["vinSupported"]).to eq(true)
        expect(policy["vrmSupported"]).to eq(false)
        expect(policy["kTypeSupported"]).to eq(true)
        expect(policy["epidSupported"]).to eq(true)
        expect(policy["depositSupported"]).to eq(true)
      end

      it "has compatibility attributes" do
        expect(policy["minItemCompatibility"]).to eq(1)
        expect(policy["maxItemCompatibility"]).to eq(1000)
      end

      it "has ad format attributes" do
        expect(policy["ebayMotorsProAdFormatEnabled"]).to eq("Disabled")
        expect(policy["localMarketAdFormatEnabled"]).to eq("Disabled")
        expect(policy["sellerProvidedTitleSupported"]).to eq(true)
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for motorsListingPolicies" do
      expect(subject["motorsListingPolicies"]).to eq([])
    end
  end
end

