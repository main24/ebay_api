RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_return_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_return_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_return_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_return_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns return policies" do
      expect(subject["returnPolicies"]).to be_an(Array)
      expect(subject["returnPolicies"].count).to eq(1)
    end

    describe "return policy" do
      let(:policy) { subject["returnPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["domestic"]).to be_a(Hash)
        expect(policy["international"]).to be_a(Hash)
      end

      it "has domestic policy with proper attributes" do
        domestic = policy["domestic"]
        expect(domestic["returnsAcceptanceEnabled"]).to eq(true)
        expect(domestic["policyDescriptionEnabled"]).to eq(false)
        expect(domestic["returnShippingCostPayers"]).to eq(["SELLER", "BUYER"])
        expect(domestic["refundMethods"]).to eq(["MONEY_BACK"])
        expect(domestic["returnMethods"]).to eq(["REPLACEMENT"])
        expect(domestic["returnPeriods"]).to be_an(Array)
      end

      it "has return periods with proper attributes" do
        period = policy["domestic"]["returnPeriods"].first
        expect(period["value"]).to eq(14)
        expect(period["unit"]).to eq("CALENDAR_DAY")
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for returnPolicies" do
      expect(subject["returnPolicies"]).to eq([])
    end
  end
end

