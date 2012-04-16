require "rubygems"
require "bundler/setup"
require "representer"
require "./benchmarks/shared/benchmarker"
require "./benchmarks/shared/database"
require "./benchmarks/shared/models"
# require "./test/support/seeds"

1000.times {
  user = User.create(:name => "some user")
  message = user.messages.create(:body => "some message")
  message.attachments.create(:filename => "foo.jpg")
}

class UserRepresenter < Representer::Base
  namespace  "user"
  attributes "id", "name", "email"
end

class LightningUserRepresenter < Representer::Lightning
  namespace  "user"
  attributes "id", "name", "email"
end

class MessageAttachmentRepresenter < Representer::Lightning
  attributes "id", "filename"
end

class MessageRepresenter < Representer::Base
  attributes "id", "body", "user_id"
  fields     "user", "attachments"

  aggregate "users", "user_id" do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by { |u| u['user']['id'] }
  end

  aggregate "attachments", "id" do |aggregated_ids, representer|
    scope = Attachment.where(:message_id => aggregated_ids)
    MessageAttachmentRepresenter.new(scope).prepare.group_by { |u| u['id'] }
  end

  def user(hash)
    if found = aggregated_users[hash['id']]
      found.first['user']
    end
  end

  def attachments(hash)
    aggregated_attachments[hash['id']] || []
  end

end

class SimpleMessageRepresenter < Representer::Simple
  attributes "id", "body"
  fields     "user", "attachments"

  aggregate "users", "user_id" do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by { |u| u['user']['id'] }
  end

  aggregate "attachments", "id" do |aggregated_ids, representer|
    scope = Attachment.where(:message_id => aggregated_ids)
    MessageAttachmentRepresenter.new(scope).prepare.group_by { |u| u['id'] }
  end

  def user(record)
    if found = aggregated_users[record.user_id]
      found.first['user']
    end
  end

  def attachments(record)
    aggregated_attachments[record.id] || []
  end

end

benchmarker        = Benchmarker.new(50)

# report = benchmarker.run("lightning represent") do
#   scope              = User.where({})
#   base_representer   = LightningUserRepresenter.new(scope)
#   base_representer.render(:json)
# end
#
# puts report

scope              = Message.where({})
simple_representer = MessageRepresenter.new(scope)

report = benchmarker.run("base represent") do
  scope              = Message.where({}).limit(50)
  base_representer   = MessageRepresenter.new(scope)
  base_representer.render(:json)
end

puts report

scope              = Message.where({})
simple_representer = SimpleMessageRepresenter.new(scope)

report = benchmarker.run("simple represent") do
  scope              = Message.where({}).limit(50)
  simple_representer = SimpleMessageRepresenter.new(scope)
  simple_representer.render(:json)
end

puts report

