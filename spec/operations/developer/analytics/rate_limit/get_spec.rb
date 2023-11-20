# frozen_string_literal: true

RSpec.describe EbayAPI, '.developer.analytics.rate_limit.get' do
  let(:client) { described_class.new(settings) }
  let(:settings) { yaml_fixture_file('settings.valid.yml') }

  before { stub_request(:get, url).to_return(response) }

  shared_examples_for 'requesting corresponding data' do
    it 'returns data for all APIs' do
      expect(subject).to be_an(Array)

      subject.each do |api_usage_stats|
        expect(api_usage_stats.keys)
          .to match_array(%w[apiContext apiName apiVersion resources])
      end

      expect(subject.map { |api_usage_stats| api_usage_stats['apiContext'] }.uniq)
        .to match_array(expected_api_contexts)

      expect(a_request(:get, expected_url)).to have_been_made
    end
  end

  context 'when api_context is passed' do
    subject { client.developer.analytics.rate_limit.get(api_context: 'sell') }

    let(:url) do
      'https://api.ebay.com/developer/analytics/v1_beta/rate_limit?api_context=sell'
    end

    let(:response) do
      open_fixture_file 'developer/analytics/rate_limit/get/api_context_response'
    end

    it_behaves_like 'requesting corresponding data' do
      let(:expected_url) { url }
      let(:expected_api_contexts) { %w[sell] }
    end
  end

  context 'when api_name is passed' do
    subject { client.developer.analytics.rate_limit.get(api_name: 'Negotiation') }

    let(:url) do
      'https://api.ebay.com/developer/analytics/v1_beta/rate_limit?api_name=Negotiation'
    end

    let(:response) do
      open_fixture_file 'developer/analytics/rate_limit/get/api_name_response'
    end

    it_behaves_like 'requesting corresponding data' do
      let(:expected_url) { url }
      let(:expected_api_contexts) { %w[sell] }
    end
  end

  context 'when both api_name and api_context are passed' do
    subject { client.developer.analytics.rate_limit.get(api_context: 'sell', api_name: 'Negotiation') }

    let(:url) do
      'https://api.ebay.com/developer/analytics/v1_beta/rate_limit?api_context=sell&api_name=Negotiation'
    end

    let(:response) do
      open_fixture_file 'developer/analytics/rate_limit/get/api_context_and_name_response'
    end

    it_behaves_like 'requesting corresponding data' do
      let(:expected_url) { url }
      let(:expected_api_contexts) { %w[sell] }
    end
  end

  context 'when no additional paras are passed' do
    subject { client.developer.analytics.rate_limit.get }

    let(:url) do
      'https://api.ebay.com/developer/analytics/v1_beta/rate_limit'
    end

    let(:response) do
      open_fixture_file 'developer/analytics/rate_limit/get/no_params_response'
    end

    it_behaves_like 'requesting corresponding data' do
      let(:expected_url) { url }
      let(:expected_api_contexts) { %w[buy commerce sell] }
    end
  end

  context 'when no data is found for the given params' do
    subject { client.developer.analytics.rate_limit.get(api_context: 'random') }

    let(:url) do
      'https://api.ebay.com/developer/analytics/v1_beta/rate_limit?api_context=random'
    end

    let(:response) do
      open_fixture_file 'developer/analytics/rate_limit/get/no_data_response'
    end

    it 'returns true' do
      is_expected.to be_truthy

      expect(a_request(:get, url)).to have_been_made
    end
  end
end
