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

# class MessageRepresenter < Representer::Lightning
#   namespace  "message"
#   attributes "id", "body", "user_id"
#   fields     "user", "attachments"

#   def after_prepare(prepared)
#     scope        = User.where(:id => self.aggregates["user_ids"])
#     @users       = UserRepresenter.new(scope).prepare.group_by do |repr|
#                     repr["user"]["id"]
#                    end
#     scope        = Attachment.where(:message_id => self.aggregates["id"])
#     @attachments = AttachmentRepresenter.new(scope).prepare.group_by do |repr|
#                     repr["attachment"]["id"]
#                   end
#     super
#   end

#   def first_pass(object)
#     (self.aggregates['user_ids'] ||= []).push object['user_id']
#     super
#   end

#   def user(hash)
#     if found = @users[hash.delete('user_id')]
#       found.first
#     end
#   end

#   def attachments(hash)
#     @attachments[hash['id']]
#   end

# end

class MessageRepresenter < Representer::Lightning
  namespace  "message"
  attributes "id", "body", "user_id"
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
    if found = aggregated_users[record['user_id']]
      found.first['user']
    end
  end

  def attachments(record)
    aggregated_attachments[record['id']] || []
  end

end


