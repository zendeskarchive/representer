class SpecRepresenter < Representer::Base
end

class UserRepresenter < Representer::Base
  namespace  :user
  attributes :id, :name, :email
end

class LightningUserRepresenter < Representer::Lightning
  namespace  :user
  attributes :id, :name, :email
end

class MessageAttachmentRepresenter < Representer::Lightning
  attributes :id, :filename
end

class MessageRepresenter < Representer::Base
  attributes :id, :body, :user_id
  fields     :user, :attachments

  aggregate :users, :user_id do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by { |u| u['user']['id'] }
  end

  aggregate :attachments, :id do |aggregated_ids, representer|
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
  attributes :id, :body
  fields     :user, :attachments

  aggregate :users, :user_id do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by { |u| u['user']['id'] }
  end

  aggregate :attachments, :id do |aggregated_ids, representer|
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

class AssociatedMessageRepresenter < Representer::Simple
  attributes :id, :body

  belongs_to :user
  has_many   :attachments, :representer => MessageAttachmentRepresenter
end

class MessageWithAttachmentRepresenter < MessageRepresenter

  fields :attachment

  # aggregate "id" do |aggregated|
  #   @attachments = Attachment.where(:message_id => @ids).group_by(&:id)
  # end

  def attachment(hash)
    if found = @users[hash['id']]
      found
    end
  end

end

class DummyPreparationRepresenter < Representer::Base

  attributes :name

  def first_name(hash)
    hash["name"].split(" ").first
  end

end

class DummyPreparationArrayedMethodsRepresenter < Representer::Base

  attributes :name

  methods ["final_label", "custom_method"]
  fields  ["custom_label", "custom_field"]

  def first_name(hash)
    hash["name"].split(" ").first
  end

  def custom_field(hash)
    hash["name"].upcase.reverse
  end

end

class DummyPreparationHashedMethodsRepresenter < Representer::Base

  attributes "name"

  methods :custom_method => "final_label"
  fields  :custom_field  => "custom_label"

  def first_name(hash)
    hash["name"].split(" ").first
  end

  def custom_field(hash)
    hash["name"].upcase.reverse
  end

end
