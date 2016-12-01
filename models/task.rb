class Task < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :name
  validates_presence_of :user_id
  
  def to_s
    if is_complete 
      "#{name} (Complete)"
    else
      "#{name} (Incomplete)"
    end
  end

  
end