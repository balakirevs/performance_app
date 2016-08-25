class Teacher < ActiveRecord::Base
  has_many :courses, dependent: :destroy

  after_commit :invalidate_cache

private

  def invalidate_cache
    Rails.cache.delete('teachers-count')
    Rails.cache.delete('teachers-max-updated-at')
  end
end
