class CreateDesignerFinanceInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :designer_finance_infos, id: :uuid do |t|
      t.string :bank_name,                 null: false, default: ''
      t.string :bank_branch,               null: false, default: ''
      t.string :ifsc_code,                 null: false, default: ''
      t.string :account_number,            null: false, default: ''
      t.string :blank_cheque_proof,        null: false, default: ''
      t.string :personal_pan_number,       null: false, default: ''
      t.string :personal_pan_number_proof, null: false, default: ''
      t.string :business_pan_number,       null: false, default: ''
      t.string :business_pan_number_proof, null: false, default: ''
      t.string :tin_number,                null: false, default: ''
      t.string :tin_number_proof,          null: false, default: ''
      t.string :gstin_number,              null: false, default: ''
      t.string :gstin_number_proof,        null: false, default: ''
      t.string :business_address_proof,    null: false, default: ''
      t.references :designer, type: :uuid, index: true, foreign_key: true

      t.timestamps
    end
    add_index :designer_finance_infos, :account_number, unique: true
    add_index :designer_finance_infos, :personal_pan_number, unique: true
    add_index :designer_finance_infos, :business_pan_number, unique: true
    add_index :designer_finance_infos, :tin_number, unique: true
    add_index :designer_finance_infos, :gstin_number, unique: true
  end
end
