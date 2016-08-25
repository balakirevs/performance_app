class Enrollment < ActiveRecord::Base
  belongs_to :course, counter_cache: true, touch: true
  belongs_to :student, touch: true
end
