RSpec.describe EbayAPI, ".commerce.catalog.product_summary.search" do
  let(:url) do
    Addressable::Template.new <<~URL.strip
      https://api.ebay.com/commerce/catalog/v1_beta/product_summary/search{?params*}
    URL
  end
  let(:client)   { described_class.new(settings) }
  let(:scope)    { client.commerce.catalog.product_summary }
  let(:settings) { yaml_fixture_file(settings_file) }
  let(:version)  { "1_beta.1.0" }
  let(:settings_file) { "settings.valid.yml" }
  let(:params)   { {} }
  before do
    stub_request(:get, url).to_return {|request| response}
  end

  subject { scope.search(**params) }

  context "success" do
    context "without params" do
      let(:response) { open_fixture_file("commerce/catalog/product_summary/search/without-params") }

      it do
        expect { subject }.to raise_error(EbayAPI::Error) do |ex|
          expect(ex.code).to eq 75_001
          expect(ex.message).to match \
            /The call must have a valid 'q'/
        end
      end
    end

    context "with keywords" do
      let(:response) { open_fixture_file("commerce/catalog/product_summary/search/matched-with-keywords") }
      let(:params) { { keywords: "ipad" } }

      it "returns list of catalog products" do
        expect(subject["productSummaries"].count).to eq(2)
      end

      describe "#a catalog product" do
        let(:catalog_product) { subject["productSummaries"].first }

        it "has proper attributes" do
          expect(catalog_product["epid"]).to eq("241996593")
          expect(catalog_product["brand"]).to eq("Apple")
        end
      end
    end
  end

  context "when not found any catalog products" do
    let(:response) { open_fixture_file("commerce/catalog/product_summary/search/no-matching") }
    let(:params) { { keywords: "blabla" } }

    it { is_expected.to be_empty }
  end
end
