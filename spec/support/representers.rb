class SpecRepresenter < Representer::Base
end

class UserRepresenter < Representer::Base
  namespace  "user"
  attributes "id", "name", "email"
end

class MessageRepresenter < Representer::Base
  attributes "id", "body", "user_id"
  fields     "user"

  # aggregate "user_id" do |aggregated|
  #   @users = User.where(:id => aggregated).group_by(&:id)
  # end

  def before_prepare
    @user_ids = []
  end

  def after_prepare(prepared)
    @users = User.where(:id => @user_ids).group_by(&:id)
    super
  end

  def first_pass(object)
    @user_ids.push object.user_id
    super
  end

  def user(hash)
    if found = @users[hash.delete('user_id')]
      found.first
    end
  end

end
