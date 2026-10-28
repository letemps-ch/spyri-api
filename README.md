# SpyriApi

Ruby client library for the Spyri API

## Installation

### RubyGems

Just excute:

    $ bundle add 'spyri-api'

### Manually

Add this line to your application's Gemfile:

```ruby
gem 'spyri-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install spyri-api

## Usage

### Quickstart

Requests are signed with HMAC-SHA256:  
```ruby
begin
  client = SpyriApi::Client.new({
    access_uuid: 'YOUR_ACCESS_UUID',
    secret: 'YOUR_SECRET',
    host: 'YOUR_SPYRI_API_URL'
  })
  users_endpoint = SpyriApi::Users.new(client)
  results = users_endpoint.search(email: "toto@test.com")
  p results
rescue SpyriApi::Error => e
  puts "Error: #{e}"
end
```

## API Documentation

You can find documentation about the Spyri API on the [developers website](https://developers.letemps.ch/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/letemps-ch/spyri-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
