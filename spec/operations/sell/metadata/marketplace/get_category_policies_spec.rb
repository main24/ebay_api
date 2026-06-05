RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_category_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_category_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_category_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_category_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns category policies" do
      expect(subject["categoryPolicies"]).to be_an(Array)
      expect(subject["categoryPolicies"].count).to eq(1)
    end

    describe "category policy" do
      let(:policy) { subject["categoryPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["autoPayEnabled"]).to eq(true)
        expect(policy["orra"]).to eq(true)
        expect(policy["minimumReservePrice"]).to eq(0.0)
        expect(policy["paymentMethods"]).to eq(["CASH_ON_PICKUP"])
        expect(policy["intangibleEnabled"]).to eq(false)
        expect(policy["valueCategory"]).to eq(false)
      end

      it "has product identifier support attributes" do
        expect(policy["isbnSupport"]).to eq("DISABLED")
        expect(policy["upcSupport"]).to eq("ENABLED")
        expect(policy["eanSupport"]).to eq("DISABLED")
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for categoryPolicies" do
      expect(subject["categoryPolicies"]).to eq([])
    end
  end
end

