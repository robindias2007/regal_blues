# frozen_string_literal: true

class V1::Users::RegistrationsController < V1::Users::BaseController
  include Registerable
end
