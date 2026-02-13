RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_listing_type_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_listing_type_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_listing_type_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_listing_type_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns listing type policies" do
      expect(subject["listingTypePolicies"]).to be_an(Array)
      expect(subject["listingTypePolicies"].count).to eq(1)
    end

    describe "listing type policy" do
      let(:policy) { subject["listingTypePolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["pickupDropOffEnabled"]).to eq(false)
        expect(policy["digitalGoodDeliveryEnabled"]).to eq(false)
      end

      it "has listing durations" do
        expect(policy["listingDurations"]).to be_an(Array)
        expect(policy["listingDurations"].count).to eq(2)
      end

      it "has auction listing duration with proper attributes" do
        auction = policy["listingDurations"].find { |ld| ld["listingType"] == "AUCTION" }
        expect(auction["durationValues"]).to eq(["DAYS_3", "DAYS_5", "DAYS_7", "DAYS_10"])
      end

      it "has fixed price listing duration with proper attributes" do
        fixed_price = policy["listingDurations"].find { |ld| ld["listingType"] == "FIXED_PRICE_ITEM" }
        expect(fixed_price["durationValues"]).to eq(["GTC"])
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for listingTypePolicies" do
      expect(subject["listingTypePolicies"]).to eq([])
    end
  end
end

