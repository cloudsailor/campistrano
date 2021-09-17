# Campistrano

## Installation

1. Add this line to your application's Gemfile:

   ```ruby
   gem 'campistrano'
   ```

2. Execute:

   ```
   $ bundle
   ```

3. Require the library in your application's Capfile:

   ```ruby
   require 'campistrano/capistrano'
   ```
## Usage

1. Configure your Basecamp3 [Chatbot](https://3.basecamp-help.com/article/160-chatbots-and-webhooks).
2. Add the following to `config/deploy.rb`:

   ```ruby
   set :campistrano, {
     webhook: 'your-chatbot-url'
   }
   ```
## Test your Configuration

Test your setup by running the following command. This will post each stage's
message to Slack in turn.

```
$ cap production basecamp:deploy:test
```

## Disabling posting to Basecamp

You can disable deployment notifications to a specific stage by setting the `:campistrano` 
configuration variable to `false` instead of actual settings.

```ruby
set :campistrano, false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/campistrano.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
