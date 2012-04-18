class UserRepresenter < Representer::Lightning
  namespace  :user
  attributes :id, :name, :email
end

class UserExportRepresenter < Representer::Lightning
  namespace  :user
  attributes :id, :name, :email, :created_at, :updated_at
end

class AttachmentRepresenter < Representer::Lightning
  namespace  :attachment
  attributes :id, :message_id, :filename
end

class MessageRepresenter < Representer::Simple
  namespace  :message
  attributes :id, :body

  belongs_to :user
  has_many   :attachments
end
