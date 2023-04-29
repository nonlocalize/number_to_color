# NumberToColor

Color code a value within a numerical range.

## Usage

```
require 'number_to_color'

ColorCode.new(value: 2, domain: [1, 3]).value_to_color
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nonlocalize/number_to_color.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
