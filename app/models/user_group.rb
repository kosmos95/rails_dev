class UserGroup < ApplicationRecord
  
  has_many :user
  
  resourcify

  rolify
  
  #def name_with_id 
  #  "#{name}(#{id})"
  #end 
  
end
