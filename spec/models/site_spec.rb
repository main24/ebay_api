RSpec.describe EbayAPI::Site do
  let(:options) do
    {
      country:    "CA",
      code:       "EBAY-CA",
      host:       "www.ebay.ca",
      languages:  %w(en-CA fr-CA),
      key:        "EBAY_CA",
      currencies: [EbayAPI::Currency["USD"], EbayAPI::Currency["CAD"]]
    }
  end

  describe "#call, #[]" do
    subject(:version) { described_class[id] }

    context "by known id" do
      let(:id) { 2 }

      it "return a proper site" do
        expect(subject.options).to eq options.merge(id: 2, languages: ["en-CA"])
      end
    end

    context "by known key" do
      let(:id) { "EBAY_CA" }

      it "return a proper site" do
        expect(subject.options).to eq options.merge(languages: %w[en-CA fr-CA])
      end
    end

    context "by known code" do
      let(:id) { "EBAY-CA" }

      it "return a proper site" do
        expect(subject.options).to eq options
      end
    end

    context "by unknown id" do
      let(:id) { 500 }

      it "raises StandardError" do
        expect { subject }.to raise_error(StandardError, /500/)
      end
    end
  end

  describe "#==" do
    let(:site) { described_class["EBAY-CA"] }

    it "returns true for the same site" do
      expect(site).to eq site
    end

    it "returns true for an equal site" do
      expect(site).to eq described_class.new(options)
    end

    it "returns false for different site" do
      expect(site).not_to eq described_class[77]
    end

    it "returns false for another object" do
      expect(site).not_to eq 2
    end
  end

  describe "#to_str" do
    subject { "#{described_class[2]}" }

    it "returns the code" do
      expect(subject).to eq "Canadian"
    end
  end

  describe ".new" do
    context "when initialized with a hash argument" do
      let(:hash_attrs) do
        {
          id: 0,
          code: "EBAY-US",
          country: "US",
          host: "www.ebay.com",
          key: "EBAY_US",
          currencies: ["USD"],
          languages: ["en-US"]
        }
      end

      it "properly initializes attributes from hash" do
        site = described_class.new(hash_attrs)
        expect(site.id).to eq(0)
        expect(site.code).to eq("EBAY-US")
        expect(site.country).to eq("US")
        expect(site.host).to eq("www.ebay.com")
        expect(site.key).to eq("EBAY_US")
        expect(site.currencies.first.code).to eq("USD")
        expect(site.languages.first).to eq("en-US")
      end
    end

    context "when initialized with keyword arguments" do
      it "properly initializes attributes from keywords" do
        site = described_class.new(
          id: 0,
          code: "EBAY-US",
          country: "US",
          host: "www.ebay.com",
          key: "EBAY_US"
        )
        expect(site.id).to eq(0)
        expect(site.code).to eq("EBAY-US")
        expect(site.country).to eq("US")
        expect(site.host).to eq("www.ebay.com")
      end
    end
  end
end
