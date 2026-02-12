RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_listing_structure_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_listing_structure_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_listing_structure_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_listing_structure_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns listing structure policies" do
      expect(subject["listingStructurePolicies"]).to be_an(Array)
      expect(subject["listingStructurePolicies"].count).to eq(1)
    end

    describe "listing structure policy" do
      let(:policy) { subject["listingStructurePolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["variationsSupported"]).to eq(true)
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for listingStructurePolicies" do
      expect(subject["listingStructurePolicies"]).to eq([])
    end
  end
end

