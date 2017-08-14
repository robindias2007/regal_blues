# frozen_string_literal: true

class SmsService
  TWILIO_FROM_NUMBER = '+13126264367'
  MSG91_BASE_URL = "https://control.msg91.com/api/sendhttp.php?authkey=#{Rails.application.secrets.msg91_auth_key}"

  def self.send_twilio_otp_to(user, otp)
    Twilio::REST::Client.new.messages.create(
      to:   user.mobile_number,
      from: TWILIO_FROM_NUMBER,
      body: msg_body(otp)
    )
  end

  def self.send_msg91_otp_to(user, otp)
    msg = msg_body(otp)
    HTTParty.get(MSG91_BASE_URL, query: {
      mobiles: user.mobile_number, message: URI.encode(msg), sender: 'AMIDOS', route: 4, country: 91
      })
  end

  def self.msg_body(otp)
    "Your OTP is #{otp}"
  end

  def self.send_otp_to(user, otp)
    if user.mobile_number.first(3) == '+91'
      send_msg91_otp_to(user, otp)
    else
      send_twilio_otp_to(user, otp)
    end
  end
end
