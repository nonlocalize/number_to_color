
# NumberToColor
Color code a value within a numerical range. Defaults to a linear gradient between red (![#ef4444](https://placehold.co/15x15/ef4444/ef4444.png) "negative") and blue (![#0ea5e9](https://placehold.co/15x15/0ea5e9/0ea5e9.png) "positive"), with white as the midpoint for "neutral" or average.

  

## Usage

### Params
* `value`: The numerical value to color code for.

* `domain`: The numerical domain, or "range", for the color gradient. This can be a 2 or 3-item array. In a 2-item array, the midpoint is automatically set as the "neutral" value/color. In a 3-item array, you can set the midpoint to be anywhere between the first and last item (e.g., `[0, 5, 7]`).

* `neutral_color` / `positive_color` / `negative_color`: (optional) Custom colors that can be passed in to override the defaults. These can be hex or RGB codes.
<br>

To get started, require the gem in your file.
```

require 'number_to_color'

```

 
### Examples
#### Simple linear range between two numbers
```
ColorCode.new(value: 2, domain: [1, 3]).to_hex

// #ffffff (neutral color)
```

  

#### Non-linear range
```
ColorCode.new(value: 5, domain: [1, 5, 7]).to_hex

// #ffffff (neutral color)
```

  

#### Inverted domain
```
ColorCode.new(value: 1, domain: [7, 1]).to_hex

// #0ea5e9 ("good" color)
```

  

#### Custom "positive" color
```
ColorCode.new(value: 1, domain: [0, 1], positive_color: '#ffffff").to_hex

// #ffffff (our new "positive" color)
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/nonlocalize/number_to_color.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
