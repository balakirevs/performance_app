class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :courses, :teacher_id
    add_index :enrollments, :course_id
    add_index :enrollments, :student_id
    add_index :enrollments, [:course_id, :student_id]
  end
end
