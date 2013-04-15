class CreateHashTags < ActiveRecord::Migration
  def change
    create_table :hash_tags do |t|
      t.references :tag, index: true
      t.references :micropost, index: true

      t.timestamps
    end
  end
end
