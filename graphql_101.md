# GraphQL 101

## What is GraphQL?
A replacement for REST architecture.

## Why?
It's more flexible that REST. It allows more the FE and BE to be more loosely coupled.

Instead of maintaining one endpoint for each request (be that GET / POST / PUT, doesn't matter), _all_ interaction from FE is to a single GraphQL endpoint.

FE Developers are free to do as they wish with existing BE. For them it is more _flexible_

From the POV of moving bits and bytes, GraphQL prevents the problem of _oversending_ or _undersending_ - the FE request explicitly asks for all the required data, and all this data is sent, and not more.


## Style
GraphQL favours configuration over convention. Compared to Rails it is more verbose and fiddly, but the tradeoff is that all configuration is visible and explicit.


## Getting Started
Stand up a quick rails app as follows; _basic rails stuff is outside scope of this note_:
```sh
$ rails new bloggo -T --skip-turbolinks -d postgresql --api
```

Add the following fields and relationships to the app;
```
User (model)
- name (field)
- address (fields)
- Post (model)
  - body (field)
  - Comment (model)
    - body (field)
```
Seed the database with some users and some blog posts & comments

Add the following to the Gemfile: `gem 'graphql'`

Download _GraphiQL_ - a tool for sending GraphQL requests. Like _Postman_ bur for GraphQL rather than REST.
https://www.electronjs.org/apps/graphiql

```shell
$ brew install --cask graphiql
$ rails g graphql:install
```

## Retreive / Query
Looking here at the R in CRUD.
Important to note that all GraphQL requests are POST requests to the single endpoint

### Entry Point
Root level fields (entry points for queries) must be defined in the class `QueryType` in the file `app/graphql/types/query_type.rb`
Example - `user`

```ruby
field :user, Types::UserType, null: false do
  argument :id, ID, required: true
end
```
#### field definition
`field` is a pseudo-method with the following parameters:
- `:user` the name of the _resolver method_
- `Types::UserType` the _type_ of the return value for this resolver method of this query.
  The canonical types are
  - ID
  - String
  - Int
  - Float
  If the method is to return an array, it is described thus: `[String]`
  And custom types, as in out example above, are fully described in their own class. Note that all of the GraphQL Types, from this main (controller?) `QueryType` to all of the custom types, all inhabit the namespace `Types::` and inherit from `Types::BaseObject`
- `null: false` - is not nullable. cannot return a null value

We then pass it a block
`argument` is a pseudo-method with the following parameters:
`:id` - the name of the parameter it will pass to the resolver method
`ID` - the type of the parameter
`required: true`

```ruby
def user(id:)
  User.find(id)
end
```
#### resolver method
The resolver method must have the same name as stated above in the `field` method call, and accepts named arguments as described in the argument definition  in the block we pass to that method.
After that it is plain old ruby.

### CustomType - UserType
In the entry point above we have specified that the query `user` will return a response of type `Types::UserType`, so now we have to define that type.

```ruby
class Types::UserType < Types::BaseObject
  description 'A user of this blog'

  field :id, ID, null: true
  field :first_name, String, null: false, camelize: false
  field :last_name, String, null: false, camelize: false
  field :street, String, null: false
  field :number, String, null: false
  field :city, String, null: false
  field :postcode, String, null: false
  field :country, String, null: false

end
```

As a first pass
#### description
The pseudo method `description` takes a string argument, and is used for the self documenting nature of GraphQL - this description will be shown in the GraphiQL explorer for instance

#### field
The pseudo method `field` takes a list of arguments, basically the same as described in the Entry Point section above.

Here we can see the truth of _configuration over convention_. Each of the User Model attributes is repeated here along with its GraphQL _type_, its _nullable_ status, and a camelization setting (default is true).
These Model attribute fields do _not_ require a resolver field.

#### 2nd pass - Custom fields
will need a field definition and a resolver function, as follows:

```ruby
field :address, String, null: false

def address
  [object.number, object.street, object.city, object.postcode, object.country].compact.join(' ')
end
```
The `object` above can be considered the same as `self` and refers to the instance of user (user type?)

===

And then for the colection of related (children) posts for this user;

```ruby
field :posts, [Types::PostType], null: false

def posts
  object.posts
end
```

Note that
- we are referring to _another_ custom type `Types::PostType`
- we expect the resolver method to return an array (type definition is wrapped in `[]`)

### Sending the GraphQL query
Once the back End is setup, we can send a GraphQL Query. This the simplest query, and will return only what we already know:
#### Query:


```json
query {
	user(id:"55")
}
```
#### Response:
```json
{
  "data": {
    "user": {
      "id": "55"
    }
  }
}
```

But let's expand it, first to return some top level data:
#### Query:
```json
query {
	user(id:"55") {
	  id
    first_name
    last_name
    address
	}
}
```
#### Response:
```json
{
  "data": {
    "user": {
      "id": "55",
      "first_name": "Louise",
      "last_name": "Brown",
      "address": "21 Boyd Parade Melbourne 1947 Australia"
    }
  }
}
```



A further expansion, adding in the first child level related data:
#### Query:
```graphql
query {
	user(id:"55") {
	  id
    first_name
    last_name
    address
    posts{
      id
      body
    }
	}
}
```
#### Response:
```json
{
  "data": {
    "user": {
      "id": "55",
      "first_name": "Louise",
      "last_name": "Brown",
      "address": "21 Boyd Parade Melbourne 1947 Australia",
      "posts": [
        {
          "id": "34",
          "body": "lorem ipsum bacon"
        },
        {
          "id": "35",
          "body": "I went on a lovely trip last weekend"
        }
      ]
    }
  }
}
```

Conclusion:
That's the basics for Retreive, now for CrUD...


## Updating the Back End - Mutations
Looking here at the C*UD in CRUD.
Important to note that all GraphQL requests are POST requests to the single endpoint
All _mutations_ are described in the entry point class `MutationType` in `app/graphql/types/mutation_type.rb`, which lives in the namespace `Types::` and inherits from `Types::BaseObject`

## Creating a Record with GraphQL

The first way is to put all of the code here in the entry point file. We will refactor later.
Again, configuration over convention makes this section quite long winded, but explicit.

### Creating the MutationType entry point.
Just as there is a single entry point for all of the Retreive / Select queries (QueryType / query_type), so we have one entry point for the Create / Update / Delete queries (MutationType / mutation_type)
In this file we will define the individual queries, and initially, all of the required arguments and the resolver functions.

```ruby
module Types
  class MutationType < Types::BaseObject
    field :create_user, Types::UserType, null: true, description: 'Create a User' do
      argument :first_name, String, required: false, camelize: false
      argument :last_name, String, required: false, camelize: false
      argument :street, String, required: false
      argument :number, String, required: false
      argument :city, String, required: false
      argument :postcode, String, required: false
      argument :country, String, required: false
    end

    def create_user(first_name:, last_name:, street:, number:, city:, postcode:, country:)
      User.create(
        first_name: first_name,
        last_name: last_name,
        street: street,
        number: number,
        city: city,
        postcode: postcode,
        country: country
      )
    end
  end
end
```

- the name of the class is `MutationType` inhabiting the namespace `Types::` and inheriting from `Types::BaseObject`
- The name of our first query is `create_user`.
  - it will return a result of type `Types::UserType`
  - it cannot return a null value
  - it has a description used by the self documenting feature.
- ALl of the arguments required to _Create_ a user are listed, along with their GraphQL characteristics.
  - (Although `required: false` is listed, omitting these does cause an exception, this is due to them being named arguments in the resolver function below which does not have default values
- There is a _resolver function_ with the same name as the query above.
  - All of the arguments from the query are passed on to the resolver function as named arguments.
  - The resolver function
    - **Creates** the user _and_
    - **Returns** the user to the calling function, which in turn will return the result to the calling GraphQL query.

### Calling the Mutation Query

#### Query
```json
mutation {
  createUser(
    first_name:"Obi Wan",
    last_name:"Kenobi",
    number:"23",
    street:"Seventh Avenue",
    city:"Berala",
    postcode:"2141",
    country:"Tattoine"
  ) {
    id
  }
}
```
- all `mutation` queries must be precedded by the keyword `mutation`
- then we call on the specific query (which is currently camelized) and pass it all the required details. Later we will refactor to use variables appropriately
- the minimum return data is automatically completed for us, we could add in here any other data we would like to have returned.

#### Response
```json
{
  "data": {
    "createUser": {
      "id": "61"
    }
  }
}
```

### Refactor One
Move as much of the code as we can out of the main entry point for all mutations and into an individual file for the Create Author action

- Create a class `CreateAuthor` in the file `app/graphql/mutations/create_user.rb` which inhabits the namespace `Mutations::` and inherits from `GraphQL::Schema::Mutation`

```ruby
class Mutations::CreateUser < GraphQL::Schema::Mutation
  null true

  argument :first_name, String, required: false, camelize: false
  argument :last_name, String, required: false, camelize: false
  argument :street, String, required: false
  argument :number, String, required: false
  argument :city, String, required: false
  argument :postcode, String, required: false
  argument :country, String, required: false

  def resolve(first_name:, last_name:, street:, number:, city:, postcode:, country:)
    User.create(
      first_name: first_name,
      last_name: last_name,
      street: street,
      number: number,
      city: city,
      postcode: postcode,
      country: country
    )
  end
end
```

- null true (not sure yet)
- list all of the arguments and their GraphQL characteristics
- the resolve function is the same as the _create_user_ function from above, but _resolve_ is a special, required name for this function

- Then over in the entry point file `..graphql/types/mutation_type.rb` we can delete of the existing code, and replace it with

```ruby
field :create_user, Types::UserType, mutation: Mutations::CreateUser
```
- `create_user` remains the name of the query
- `Types::UserType` is still the Tytpe of data that we will return
- now, we delegate all of the action to the `CreateUser` class in the namespace `Mutations::` with the specification `mutation: Mutations::CreateUser`

The GraohQL query is called in exactly the same way as above

### Refactor Two
First pass Variables - replacing the arguments with variables
This change relates to the GraphQL query, and not the back end code

amend the query thus:
```json
mutation createUser(
  $first_name:String,
  $last_name:String,
  $number: String,
  $street:String,
  $city:String,
  $postcode:String,
  $country:String
){
  createUser(
    first_name:$first_name,
    last_name:$last_name,
    number:$number,
    street:$street,
    city:$city,
    postcode:$postcode,
    country:$country
  ) {
    id
  }
}
```
Note that the `CreateUser` query is listed _twice_
- once (the new one) to specify the variables and
- once (the original one) _inside the `{}` brackets_ to invoke the query

The Query variables themselves are listed in a JSON object thus:
```json
{
  "first_name": "Jessica",
  "last_name": "Billions",
  "number": "6",
  "street": "Southbank",
  "city":"London",
  "postcode": "SW1 123",
  "country": "England"
}
```

### Refactor Three

Our GraphQL query would be much nicer if we can send a single variable for `$user` as follows:

The _query_ will look like this
```json
mutation createUser($user:UserInputType!){
  createUser(user:$user) {
    id
  }
}
```
- the query _name_ is the same
- instead of invoking it with a long list of variables, we're now invoking it with a single variable of type `UserInputType`

The variable will look like this:
```json
{
  "user" :
  {
    "first_name": "Marge",
    "last_name": "Simpson",
    "number": "1638",
    "street": "Evergreen Terrace",
    "city":"Springfield",
    "postcode": "OK 1234",
    "country": "USA"
  }
}
```

Obviously the trick is to define `UserInputType` in the back end. This could be in it's own file, but for now we are adding this class to the existing file: `app/graphql/types/user_type.rb`
```ruby
class Types::UserInputType < GraphQL::Schema::InputObject
  graphql_name 'UserInputType'
  description 'All the attributes for creating a User'

  argument :first_name, String, required: false, camelize: false
  argument :last_name, String, required: false, camelize: false
  argument :street, String, required: false
  argument :number, String, required: false
  argument :city, String, required: false
  argument :postcode, String, required: false
  argument :country, String, required: false
end
```

With the _UserInputType_ now defined, we have to amend the mutation _CreateUser_ to accept this input type. The file `app/graphql/mutations/create_user.rb` should now look like:

```ruby
class Mutations::CreateUser < GraphQL::Schema::Mutation
  null true

  argument :user, Types::UserInputType, required: true

  def resolve(user:)
    User.create(user.to_h)
  end
end
```

