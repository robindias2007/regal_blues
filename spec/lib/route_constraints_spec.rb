# frozen_string_literal: true

describe RouteConstraints do
  let(:api_constraints_v1) { described_class.new(version: 1) }
  let(:api_constraints_v2) { described_class.new(version: 2, default: true) }

  describe 'matches?' do
    it "returns true when the version matches the 'Accept' header" do
      request = double(host:    'http://localhost:3000',
                       headers: { 'Accept' => 'application/vnd.regal.v1' })
      expect(api_constraints_v1.matches?(request)).to be true
    end

    it "returns the default version when 'default' option is specified" do
      request = object_double(host: 'http://localhost:3000')
      expect(api_constraints_v2.matches?(request)).to be true
    end
  end
end
