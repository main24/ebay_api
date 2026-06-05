RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_automotive_parts_compatibility_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_MOTORS_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_MOTORS_US/get_automotive_parts_compatibility_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_automotive_parts_compatibility_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_automotive_parts_compatibility_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns automotive parts compatibility policies" do
      expect(subject["automotivePartsCompatibilityPolicies"]).to be_an(Array)
      expect(subject["automotivePartsCompatibilityPolicies"].count).to eq(1)
    end

    describe "automotive parts compatibility policy" do
      let(:policy) { subject["automotivePartsCompatibilityPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("6028")
        expect(policy["categoryTreeId"]).to eq("100")
        expect(policy["maxNumberOfCompatibleVehicles"]).to eq(1000)
        expect(policy["compatibleVehicleTypes"]).to eq(["US_CARS_TRUCKS", "US_MOTORCYCLES"])
        expect(policy["compatibilityBasedOn"]).to eq("ASSEMBLY")
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for automotivePartsCompatibilityPolicies" do
      expect(subject["automotivePartsCompatibilityPolicies"]).to eq([])
    end
  end
end

