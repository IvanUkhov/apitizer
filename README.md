# Apitizer
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

## Usage
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
    show ':variant', on: :member
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
