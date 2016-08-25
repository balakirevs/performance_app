class Student < ActiveRecord::Base
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments

  after_commit :invalidate_cache

private

  def invalidate_cache
    Rails.cache.delete('students-count')
    Rails.cache.delete('students-max-updated-at')
  end
end
