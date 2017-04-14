# RubyMoney - Money Heuristics

This is a module for heuristic analysis of the string input for the
[money gem](https://github.com/RubyMoney/money). It was formerly part of the gem.

[![Gem Version](https://badge.fury.io/rb/money-heuristics.svg)](https://rubygems.org/gems/money-heuristics)
[![Build Status](https://travis-ci.org/RubyMoney/money-heuristics.svg?branch=master)](https://travis-ci.org/RubyMoney/money-heuristics)
[![Coverage Status](https://coveralls.io/repos/RubyMoney/money-heuristics/badge.svg?branch=master)](https://coveralls.io/github/RubyMoney/money-heuristics?branch=master)
[![License](https://img.shields.io/github/license/RubyMoney/money-heuristics.svg)](https://opensource.org/licenses/MIT)

## Installation

Include this line in your `Gemfile`:

```ruby
gem 'money-heuristics'
```

## Usage

```ruby
>> Money::Currency.analyze 'USD 200'
=> ["USD"]
>> Money::Currency.analyze 'zł123,000.50'
=> ["PLN"]
```

## Contributing

See the [Contribution Guidelines](https://github.com/RubyMoney/money-heuristics/blob/master/CONTRIBUTING.md)
