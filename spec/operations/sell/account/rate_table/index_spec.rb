RSpec.describe EbayAPI, ".sell.account.rate_table.index" do
  let(:client)   { described_class.new(**settings) }
  let(:scope)    { client.sell.account(version: version).rate_table }
  let(:settings) { yaml_fixture_file("settings.valid.yml") }
  let(:version)  { "1.2.0" }
  let(:url) do
    "https://api.ebay.com/sell/account/v1/rate_table/" \
      "?marketplace_id=EBAY_US"
  end

  before  { stub_request(:get, url).to_return(response) }
  subject { scope.index }

  context "success" do
    let(:response) do
      open_fixture_file "sell/account/rate_table/index/success"
    end

    let(:rate_tables) do
      yaml_fixture_file "sell/account/rate_table/index/success.yml"
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it "returns the rate tables" do
      expect(subject).to eq rate_tables
    end
  end
end
