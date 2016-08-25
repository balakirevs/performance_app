class IndexCoursesByName < ActiveRecord::Migration
  def change
    add_index :courses, :name
  end
end
