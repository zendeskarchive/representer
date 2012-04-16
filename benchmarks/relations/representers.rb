class UserRepresenter < Representer::Lightning
  namespace  "user"
  attributes "id", "name", "email"
end

class UserExportRepresenter < Representer::Lightning
  namespace  "user"
  attributes "id", "name", "email", "created_at", "updated_at"
end

class AttachmentRepresenter < Representer::Lightning
  namespace  "attachment"
  attributes "id", "message_id", "filename"
end

class MessageRepresenter < Representer::Simple
  namespace  :message
  attributes :id, :body
  fields     :user, :attachments

  # This is belongs_to
  aggregate :users, :user_id do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by do |u|
      u['user']['id']
    end.inject({}) do |memo, item|
      # We grouped, so we get a hash with ids as keys and single item arrays
      # as values. Here we convert the array to a value
      id, serialized = item
      memo[id] = serialized.first['user']
      memo
    end
  end

  def user(record)
    aggregated_users[record.user_id]
  end

  # This is has_many
  aggregate :attachments, :id do |aggregated_ids, representer|
    scope = Attachment.where(:message_id => aggregated_ids)
    AttachmentRepresenter.new(scope).prepare.group_by { |u| u['id'] }
  end

  def attachments(record)
    aggregated_attachments[record.id] || []
  end

end


