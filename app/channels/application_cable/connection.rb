# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # Identify the user by current_user
    # Add tags for better debugging
    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.id
    end

    private

    # Using the warden env, we find who is logged in and use them as the identifier
    def find_verified_user
      id = Auth.decode(request.params['jwt'])['resource']
      client = request.params['client']
      if (vu = client.capitalize.constantize.find(id))
        vu
      else
        reject_unauthorized_connection
      end
    rescue StandardError => e
      logger.add_tags 'ActionCable', 'FATAL', e
      reject_unauthorized_connection
    end
  end
end
