class User < ActiveRecord::Base
  has_many :messages
end

class Message < ActiveRecord::Base
  belongs_to :user
  has_many   :attachments

  def username
    user.name
  end
end

class Attachment < ActiveRecord::Base
  belongs_to :message
end

