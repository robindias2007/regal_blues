# frozen_string_literal: true

class SmsService
  require 'aws-sdk-sns'

  def self.msg_body(otp)
    "Your OTP is #{otp}"
  end

  def self.send_otp_to(user, otp)
    sns.publish(phone_number: user.mobile_number, message: msg_body(otp))
  end

  def self.send_otp_to_number(number, otp)
    sns.publish(phone_number: number, message: msg_body(otp))
  end

  def self.sns
    client = Aws::SNS::Client.new(region:            'us-east-1', # Don't change the region
                                  access_key_id:     Rails.application.secrets[:aws_access_key_id],
                                  secret_access_key: Rails.application.secrets[:aws_secret_access_key])
    client.set_sms_attributes(attributes: { 'DefaultSMSType' => 'Transactional', 'DefaultSenderID' => 'AM1DOS' })
  end
end
