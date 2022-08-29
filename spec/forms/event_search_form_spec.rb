# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventSearchForm do
  let(:from) { nil }
  let(:to) { nil }
  let(:url) { nil }
  let(:event_type) { nil }

  let(:params) do
    {
      from: from,
      to: to,
      url: url,
      event_type: event_type
    }
  end

  subject { described_class.new(params) }

  describe 'validations' do
    it { is_expected.to be_valid }

    context 'when from is set to a valid time' do
      let(:from) { 1.day.ago.iso8601 }

      it { is_expected.to be_valid }
    end

    context 'when to is set to a valid time' do
      let(:to) { 1.day.ago.iso8601 }

      it { is_expected.to be_valid }
    end

    context 'when from and to are set to a valid times' do
      let(:from) { 2.day.ago.iso8601 }
      let(:to) { 1.day.ago.iso8601 }

      it { is_expected.to be_valid }
    end

    context 'when from is after to' do
      let(:from) { Time.zone.now.iso8601 }
      let(:to) { 1.day.ago.iso8601 }

      it { is_expected.not_to be_valid }
    end

    context 'when event_type is set' do
      let(:event_type) { 'click' }

      it { is_expected.to be_valid }
    end

    context 'when event_type is set to an unknown event type' do
      let(:event_type) { 'what is this' }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#time_range' do
    context 'when neither from nor to are set' do
      it 'returns nil' do
        expect(subject.time_range).to eq(nil)
      end
    end

    context 'when only from parameter is set' do
      let(:from) { Time.zone.now }

      it 'returns an open range starting after from' do
        expect(subject.time_range).to eq(from..)
      end
    end

    context 'when only to parameter is set' do
      let(:to) { Time.zone.now }

      it 'returns an open range ending at to' do
        expect(subject.time_range).to eq(..to)
      end
    end

    context 'when from and to are set' do
      let(:from) { 2.days.ago }
      let(:to) { Time.zone.now }

      it 'returns an range starting at from and ending at to' do
        expect(subject.time_range).to eq(from..to)
      end
    end
  end

  describe 'scope qeuery' do
    let(:event_a) { create(:event, url: "https://a.com", event_type: "click") }
    let(:event_b) do
      create(:event,
        url: "https://b.com",
        event_type: "page_view",
        created_at: 1.day.ago)
    end
    let(:event_c) do
      create(:event,
        url: "https://c.com",
        event_type: "click",
        created_at: 2.day.ago)
    end

    context 'when url query present' do
      let(:url) { "https://b.com" }

      it 'returns only events for the given url' do
        expect(subject.scope_query(Event.all)).to eq([event_b])
      end
    end

    context 'when event_type query present' do
      let(:event_type) { "page_view" }

      it 'returns only events for the given event type' do
        expect(subject.scope_query(Event.all)).to eq([event_b])
      end
    end

    context 'when from/to query present' do
      let(:to) { 1.5.days.ago }

      it 'returns only events for the given timerange' do
        expect(subject.scope_query(Event.all)).to eq([event_c])
      end
    end
  end
end
