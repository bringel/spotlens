class UserAccount < ActiveRecord::Base
  enum :account_type => {
    :instagram => 0,
    :twitter => 1
  }
end
