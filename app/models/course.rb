class Course < ActiveRecord::Base
  belongs_to :teacher, touch: true
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments

  validates_presence_of :teacher

  after_commit :invalidate_cache

private

  def invalidate_cache
    Rails.cache.delete('courses-count')
    Rails.cache.delete('courses-max-updated-at')
  end
end
