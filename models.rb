ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
class Count < ActiveRecord::Base
end

class Photo < ActiveRecord::Base
  belongs_to :user
  has_many :groups
end

class Place < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :places
  has_many :photos
  belongs_to :user_groups
end

class Group < ActiveRecord::Base
  has_many :users
  belongs_to :photo
  belongs_to :user_groups
end

class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
