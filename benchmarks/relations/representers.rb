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
  namespace  "message"
  attributes "id", "body"
  fields     "user", "attachments"

  aggregate "users", "user_id" do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by { |u| u['user']['id'] }
  end

  aggregate "attachments", "id" do |aggregated_ids, representer|
    scope = Attachment.where(:message_id => aggregated_ids)
    AttachmentRepresenter.new(scope).prepare.group_by { |u| u['id'] }
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


