class Seeder
  def self.seed
    peter  = User.create(:name => 'Peter',   :email => "peter@email.com")
    olivia = User.create(:name => 'Olivia',  :email => "olivia@email.com")
    User.create(:name => 'Walter',  :email => "walter@email.com")
    User.create(:name => 'Astrid',  :email => "astrid@email.com")
    User.create(:name => 'Broyles', :email => "broyles@email.com")

    message = Message.create(:body => 'Bishop FTW', :user_id => peter.id)
    message2 = Message.create(:body => 'Dunham', :user_id => olivia.id)
    Attachment.create(:message => message, :filename => 'photo.jpg')
    Attachment.create(:message => message2, :filename => 'song.mp3')

    MysqlUser.create(:name => 'Walter',  :email => "walter@email.com")
    MysqlUser.create(:name => 'Astrid',  :email => "astrid@email.com")

  end
end

Seeder.seed
