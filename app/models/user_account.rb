class UserAccount < ActiveRecord::Base
  enum type: [:instagram, :twitter]
end
