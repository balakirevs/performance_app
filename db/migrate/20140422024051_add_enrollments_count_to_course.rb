class AddEnrollmentsCountToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :enrollments_count, :integer,
               null: false, default: 0
  end
end
