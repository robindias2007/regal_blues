class CreateExtensions < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'btree_gin' unless extension_enabled?('btree_gin')
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  end
end
