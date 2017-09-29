require 'spec_helper'

RSpec.describe Esplanade::Response::Doc do
  subject { described_class.new(raw_status, request) }
  let(:raw_status) { double }
  let(:request) { double }

  describe '#tomogram' do
    let(:tomogram) { {'status' => status} }
    let(:status) { double }
    let(:request) { double(doc: double(responses: [tomogram])) }
    before { allow(subject).to receive(:status).and_return(status) }
    it { expect(subject.tomogram).to eq(tomogram) }

    context 'does not have responses' do
      let(:request) { double(doc: double(responses: nil)) }
      it { expect(subject.tomogram).to be_nil }
    end
  end

  describe '#json_schemas' do
    let(:json_schema) { double }
    before { allow(subject).to receive(:tomogram).and_return([{'body' => json_schema}]) }
    it { expect(subject.json_schemas).to eq([json_schema]) }

    context 'does not have responses' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect(subject.json_schemas).to be_nil }
    end
  end

  describe '#present?' do
    before { allow(subject).to receive(:tomogram).and_return(double) }
    it { expect(subject.present?).to be_truthy }

    context 'does not have tomogram' do
      before { allow(subject).to receive(:tomogram).and_return(nil) }
      it { expect(subject.present?).to be_falsey }
    end

    context 'tomogram is empty' do
      before { allow(subject).to receive(:tomogram).and_return([]) }
      it { expect(subject.present?).to be_falsey }
    end
  end

  describe '#json_schemas?' do
    before { allow(subject).to receive(:json_schemas).and_return([double, double]) }
    it { expect(subject.json_schemas?).to be_truthy }

    context 'does not have json-schemas' do
      before { allow(subject).to receive(:json_schemas).and_return(nil) }
      it { expect(subject.json_schemas?).to be_falsey }
    end

    context 'json-schemas is empty' do
      before { allow(subject).to receive(:json_schemas).and_return([]) }
      it { expect(subject.json_schemas?).to be_falsey }
    end

    context 'not all json-schema' do
      before { allow(subject).to receive(:json_schemas).and_return([double, {}]) }
      it { expect(subject.json_schemas?).to be_falsey }
    end
  end
end
