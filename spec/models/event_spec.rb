# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    let(:url) { 'https://example.com/page/1' }
    let(:type) { 'click' }

    subject { build(:event, url: url, event_type: type)}

    it { is_expected.to be_valid }

    context 'when url is nil' do
      let(:url) { nil }

      it { is_expected.not_to be_valid }
    end

    context 'when url is empty' do
      let(:url) { "   " }

      it { is_expected.not_to be_valid }
    end


    context 'when url is not well formatted' do
      let(:url) { "{{}}.com" }

      it { is_expected.not_to be_valid }
    end

    context 'when event_type is nil' do
      let(:type) { nil }

      it { is_expected.not_to be_valid }
    end
  end
end
