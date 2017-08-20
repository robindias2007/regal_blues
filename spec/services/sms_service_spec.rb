# frozen_string_literal: true

describe SmsService do
  let(:user) { create(:user, mobile_number: '+918850594105') }

  before do
    stub_const('SmsService::TWILIO_FROM_NUMBER', 'somrandomnumber')
    stub_const('SmsService::MSG91_BASE_URL',
      "https://control.msg91.com/api/sendhttp.php?authkey=#{Rails.application.secrets.msg91_auth_key}")
  end

  context '.send_msg91_otp_to' do
    it 'sends the otp through Msg91' do
      # response = described_class.send_msg91_otp_to(user, '112233')
      # expect(response.code).to eq 200
    end
  end

  context '.send_twilio_otp_to' do
    it 'sends the otp through Twilio' do
      stub_const('Twilio::REST::Client', FakeSMS)
      described_class.twilio_client = FakeSMS
      response = described_class.send_twilio_otp_to(user, '112233')
      expect(response.first.from[:to]).to eq user.mobile_number
    end
  end

  context '.send_otp_to' do
    it 'sends the otp uses appropriate service based on country code(Rest of the world)' do
      user = create(:user, mobile_number: '+918850594105')
      allow(described_class).to receive(:send_msg91_otp_to)
      described_class.send_otp_to(user, '112233')
      expect(described_class).to have_received(:send_msg91_otp_to).with(user, '112233')
    end

    it 'sends the otp uses appropriate service based on country code(US)' do
      user = create(:user, mobile_number: '+182850594105')
      allow(described_class).to receive(:send_twilio_otp_to)
      described_class.send_otp_to(user, '112233')
      expect(described_class).to have_received(:send_twilio_otp_to).with(user, '112233')
    end
  end
end

class FakeSMS
  Message = Struct.new(:from, :to, :body)

  cattr_accessor :messages
  self.messages = []

  def messages
    self
  end

  def create(from:, to:, body:)
    self.class.messages << Message.new(from: from, to: to, body: body)
  end
end
