# This is a database view, not an actual table
class NormalizedTransaction < ActiveRecord::Base
  belongs_to :other_person, :foreign_key => 'you', :class_name => 'User'
  # belongs_to :transaction, :foreign_key => 'id'
  
  named_scope :sorted, :order => 'created_at DESC'
end