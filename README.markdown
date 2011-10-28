Representers
============

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

Representer::Lightning
-----------------------------------

Representer::Lightning is a subclass of Representer::Base, which does not instantiate ActiveRecord::Objects,
but performs a direct SQL call and creates first pass the Array of Hashes using the SQL call result.

