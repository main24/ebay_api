RSpec.describe EbayAPI, ".sell.metadata.marketplace.get_classified_ad_policies" do
  let(:client) { described_class.new(**settings) }
  let(:scope) { client.sell.metadata.marketplace(marketplace_id: "EBAY_US") }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:url) do
    "https://api.ebay.com/sell/metadata/v1/marketplace/EBAY_US/get_classified_ad_policies"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.get_classified_ad_policies }

  context "success" do
    let(:response) do
      open_fixture_file "sell/metadata/marketplace/get_classified_ad_policies/success"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns classified ad policies" do
      expect(subject["classifiedAdPolicies"]).to be_an(Array)
      expect(subject["classifiedAdPolicies"].count).to eq(1)
    end

    describe "classified ad policy" do
      let(:policy) { subject["classifiedAdPolicies"].first }

      it "has proper attributes" do
        expect(policy["categoryId"]).to eq("625")
        expect(policy["categoryTreeId"]).to eq("0")
        expect(policy["adFormatEnabled"]).to eq("Enabled")
        expect(policy["sellerContactDetailsEnabled"]).to eq(true)
      end

      it "has payment and shipping attributes" do
        expect(policy["classifiedAdPaymentMethodEnabled"]).to eq("Enabled")
        expect(policy["classifiedAdShippingMethodEnabled"]).to eq(false)
      end

      it "has best offer attributes" do
        expect(policy["classifiedAdBestOfferEnabled"]).to eq("Enabled")
        expect(policy["classifiedAdCounterOfferEnabled"]).to eq(true)
        expect(policy["classifiedAdAutoAcceptEnabled"]).to eq(true)
        expect(policy["classifiedAdAutoDeclineEnabled"]).to eq(true)
      end

      it "has contact attributes" do
        expect(policy["classifiedAdContactByPhoneEnabled"]).to eq(true)
        expect(policy["classifiedAdContactByEmailEnabled"]).to eq(true)
      end
    end
  end

  context "when no policies are available (204 No Content)" do
    let(:response) { open_fixture_file "no_content" }

    it "returns an empty array for classifiedAdPolicies" do
      expect(subject["classifiedAdPolicies"]).to eq([])
    end
  end
end

