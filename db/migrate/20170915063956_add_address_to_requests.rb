class AddAddressToRequests < ActiveRecord::Migration[5.1]
  def change
    add_reference :requests, :address, type: :uuid, index: true, foreign_key: true
  end
end
