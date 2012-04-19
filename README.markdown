Representer
============

When you're working with a Rails/Sinatra or any other web project, there is a high chance that you used `to_json` or `to_xml`. The thing is that when you did that, you just lost control over the View layer. These are methods called on a Model. You can pass options, but you would do that in the Controller. There is no View layer.

Representer fixes that by introducing an Object Oriented approach to views. You define a class which knows everything about the representation of a Model and use instances of the class to produce the serialized output.

This makes it very simple to customize, test and get sick speeds.

Representer::Base
-----------------------------------

The most basic usage is the Representer::Base. It has 3 class methods that should interest you:

* namespace  - the root of the representation
* attributes - which record attributes should be extracted during the first pass
* fields     - will call the methods with those names on the representer instance with each record as the argument

Here's what happens when you create a new instance of the representer, pass a collection or one instance as the constructor argument and call render:

1. A first pass is executed, converting the objects into Hash instances. Only the defined attributes are copied.
2. When fields are defined on a representer, a second pass is executed on the extracted Array of Hashes.
   Each defined field method is called with each hash as an argument.
   The return value of this method is stored in the hash, with the method name as the key.
3. The final hash is converted to an appropriate format.
4. Profit!

### Example

```ruby
class UserRepresenter < Representer::Base
  namespace "user"

  attributes "id", "name", "email"

  fields "something"

  def something(hash)
    "#{hash["name"]} <#{hash["email"]}>"
  end

end

users = User.limit(10)
representer = UserRepresenter.new(users)
representer.render(:json) # { "user": { "id": 1, "name": "Mike", "email": "mike@email.com", "something": "Mike <mike@email.com>" }}
```

#### attributes

The `attributes` method allows you to specify which attributes to use. The reasone it that sometimes you don't want all database columns to appear in the representation.

```ruby
class UserRepresenter < Representer::Base
  attribute: :id, :name, :email
end
```

#### fields

The `fields` method allows you to specify extra fields that appear in the representation that are not columns in the database. When you specify a field, you must implemente a method with the same name on the Representer. It will get called during the second pass, with one argument, which is a hash holding extracted attributes for one item.

```ruby
class UserRepresenter < Representer::Base
  attribute: :id, :name, :email
  fields :full_email

  def full_email(hash)
    "#{hash['name'] <#{hash['email']}>"
  end
end
```

#### aggregate

When running the first pass, it is useful to gather some specific piece of information, like all ids or some foreign keys. You can use the `aggregate` method for this. It accepts 2 arguments:

* the name of the aggregation
* what attribute to gather

You also pass it a block, which gets called with an array with aggregated values and the representer object. What you return in this block, will be available by calling self.aggregated_[name]

```ruby
class MessageRepresenter < Representer::Base
  namespace  :message
  attributes :id, :title, :body

  aggregate  :images, :id do |ids, representer|
    # This is imaginary code!! <3
    RemoteApiClient.find_images(ids).group_by(&:message_id)
  end

  fields     :images

  def images(message)
    self.aggregated_images[message['id']]
  end
end
```

Representer::Simple
-------------------

Representer::Base is very good at performance, but it requires you to work
with hashes. If you prefer to work with ActiveRecord objects, use `Representer::Simple`. It works the same way, but instead of passing the hashes to the methods specified in fields, it passes the ActiveRecord instance. It makes the representer code cleaner.

Chech out this example:

```ruby
class SimpleMessageRepresenter < Representer::Simple
  attributes :id, :body
  fields     :username

  def username(record)
    record.user.name.capitalize
  end

end
```

Produces:

```json
{
  "message" => {
    "id" => 1,
    "body" => "WAT",
    "username" => "Mark"
  }
}
```

Representer::Lightning
-----------------------------------

Representer::Lightning is a subclass of Representer::Base, which does not
instantiate ActiveRecord::Objects, but performs a direct SQL call and creates
first pass the Array of Hashes using the SQL call result.

When using Lightning, you can work on hashes and attributes you spefice using `attributes`.

```ruby
class SimpleMessageRepresenter < Representer::Lightning
  attributes :id, :body
end
```

