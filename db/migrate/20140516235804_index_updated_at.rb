class IndexUpdatedAt < ActiveRecord::Migration
  def change
    add_index :courses, :updated_at
    add_index :teachers, :updated_at
    add_index :students, :updated_at
  end
end
