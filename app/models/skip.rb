class Skip < ActiveRecord::Base
	
	belongs_to :skipper, class_name: "User"
  	belongs_to :skipped, class_name: "User"

  	

end
