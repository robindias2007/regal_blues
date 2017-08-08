class CreateExtensions < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'btree_gin' unless extension_enabled?('btree_gin')
    enable_extension 'btree_gist' unless extension_enabled?('btree_gist')
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
  end
end
