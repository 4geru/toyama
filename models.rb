ActiveRecord::Base.establish_connection(ENV['DATABASE_URL']||"sqlite3:db/development.db")
class Count < ActiveRecord::Base
end

class Photo < ActiveRecord::Base
  belongs_to :user
end

class Place < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :places
  has_many :photos
end
