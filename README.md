# Apitizer [![Gem Version](https://badge.fury.io/rb/apitizer.svg)](http://badge.fury.io/rb/apitizer) [![Build Status](https://travis-ci.org/IvanUkhov/apitizer.svg?branch=master)](https://travis-ci.org/IvanUkhov/apitizer)
The main ingredient of a RESTful API client.

## Installation
Add the following line to your `Gemfile`:

```ruby
gem 'apitizer'
```

Then execute:

```bash
$ bundle
```

Alternatively, you can install the gem manually:

```bash
$ gem install apitizer
```

Note that the minimal supported version of Ruby is `2.1`.

## Usage
Create an apitizer describing the API of the Web service you would like
to interact with:

```ruby
apitizer = Apitizer::Base.new do
  address 'https://service.com/api'

  resources :posts do
    resources :comments
  end
end
```

The apitizer can now be used to manipulate the resources provided by the
Web service. To this end, there are five methods: `index`, `show`, `create`,
`update`, and `delete`, which can be used as shown below.

To list the members of a collection:

```ruby
apitizer.index(:posts)
apitizer.index(:posts, post_id, :comments)
```

To read a member of a collection:

```ruby
apitizer.show(:posts, post_id)
apitizer.show(:posts, post_id, :comments, comment_id)
```

To create a new member in a collection:

```ruby
apitizer.create(:posts, title: 'To be or not to be')
apitizer.create(:posts, post_id, :comments, content: 'That is the question.')
```

To update a member of a collection:

```ruby
apitizer.update(:posts, post_id, title: 'What is the meaning of life?')
apitizer.update(:posts, post_id, :comments, comment_id, content: '42.')
```

To delete a member of a collection:

```ruby
apitizer.delete(:posts, post_id)
apitizer.delete(:posts, post_id, :comments, comment_id)
```

## Example
Here is an example for the [Typekit API](https://typekit.com/docs/api).
Check out [Typekit Client](https://github.com/IvanUkhov/typekit-client)
as well.

Code:

```ruby
require 'apitizer'

options = {
  # Format
  format: :json,
  # Authorization
  headers: { 'X-Typekit-Token' => ENV['tk_token'] },
  # Non-standard REST-HTTP mapping
  dictionary: { update: :post }
}

apitizer = Apitizer::Base.new(options) do
  address 'https://typekit.com/api/v1/json'

  resources :families, only: :show do
    show ':variation', on: :member
  end

  resources :kits do
    resources :families, only: [ :show, :update, :delete ]
    show :published, on: :member
    update :publish, on: :member
  end

  resources :libraries, only: [ :index, :show ]
end

puts JSON.pretty_generate(apitizer.index(:kits))
```

Output:

```json
{
  "kits": [
    {
      "id": "bas4cfe",
      "link": "/api/v1/json/kits/bas4cfe"
    },
    {
      "id": "sfh6bkj",
      "link": "/api/v1/json/kits/sfh6bkj"
    },
    {
      "id": "kof8zcn",
      "link": "/api/v1/json/kits/kof8zcn"
    },
    {
      "id": "zyx4wop",
      "link": "/api/v1/json/kits/zyx4wop"
    }
  ]
}
```

## History
Apitizer was a part of
[Typekit Client](https://github.com/IvanUkhov/typekit-client).

## Contributing
1. Fork it ( https://github.com/IvanUkhov/apitizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
