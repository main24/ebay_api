RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_item_condition_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_item_condition_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_item_condition_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_item_condition_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns item condition policies" do
      expect(subject["itemConditionPolicies"]).to be_an(Array)
      expect(subject["itemConditionPolicies"].count).to eq(1)
    end

    describe "item condition policy" do
      let(:policy) { subject["itemConditionPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["itemConditionRequired"]).to eq(true)
        expect(policy["itemConditions"]).to be_an(Array)
      end

      it "has item conditions with proper attributes" do
        condition = policy["itemConditions"].first
        expect(condition["conditionId"]).to eq("1000")
        expect(condition["conditionDescription"]).to eq("Brand new, unused, and unworn")
      end
    end
  end
end

