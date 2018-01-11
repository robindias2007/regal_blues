class AddShippingPriceToOfferQuotations < ActiveRecord::Migration[5.1]
  def change
    add_column :offer_quotations, :shipping_price, :integer
  end
end
