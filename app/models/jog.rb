class Jog < ApplicationRecord
  belongs_to :user
  validates_numericality_of :distance, :allow_nil => true
  validates_numericality_of :duration 
end
