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

  def self.send_message_notification(number, message)
    number = "+917803827212" #ankit, This number is used for testing purpose
    # number = "+918103257148"  # This number is used for testing purpose
    sns.publish(phone_number: number, message: message)
  end

  def self.sns
    client = Aws::SNS::Client.new(region:            'us-east-1', # Don't change the region
                                  access_key_id:     ENV['AWS_ACCESS_KEY'],
                                  secret_access_key: ENV['AWS_SECRET_KEY'])
    client.set_sms_attributes(attributes: { 'DefaultSMSType' => 'Transactional', 'DefaultSenderID' => 'AM1DOS' })
    client
  end
end
