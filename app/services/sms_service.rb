# frozen_string_literal: true

class SmsService
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
    require 'aws-sdk'
    Aws::SNS::Client.new(region:            'us-east-1', # Don't change the region
                         access_key_id:     Rails.application.secrets[:aws_access_key_id],
                         secret_access_key: Rails.application.secrets[:aws_secret_access_key])
  end
end
