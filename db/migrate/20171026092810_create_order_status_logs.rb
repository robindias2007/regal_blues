class CreateOrderStatusLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :order_status_logs, id: :uuid do |t|
      t.references :order, type: :uuid, index: true, foreign_key: true
      t.datetime :started_at
      t.datetime :paid_at
      t.datetime :designer_confirmed_at
      t.datetime :measurements_given_at
      t.datetime :in_production_at
      t.datetime :shipped_to_qc_at
      t.datetime :delivered_to_qc_at
      t.datetime :in_qc_at
      t.datetime :shipped_to_user_at
      t.datetime :delivered_to_user_at
      t.datetime :rejected_by_qc_at
      t.datetime :user_awaiting_more_options_at
      t.datetime :designer_gave_more_options_at
      t.datetime :user_selected_options_at
      t.datetime :user_cancelled_at
      t.datetime :designer_selected_fabric_unavailable_at

      t.timestamps
    end
  end
end
