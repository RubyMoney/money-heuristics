⚠️ **Maintainer(s) Wanted — RubyMoney Needs New Stewardship**  

Hi! I’m the current (and only) active maintainer, and I no longer have the capacity to look after this project—or any other gems under the **RubyMoney** GitHub organization.  

**What we’re looking for:** An individual or team willing to take ownership of *the entire organization* (all gems, docs, CI, and Rubygems ownership).  

**Timeline**  

| Date | Action |
|------|--------|
| **Now → 30 Sep 2025** | Open an issue titled “Maintainer application” (or email `shane@emmons.io`) and tell us who you are, why you care, and your plan for the libraries. |
| **1 Oct 2025** | If no successor is confirmed, every repository in RubyMoney will be **archived (read-only)**. No new issues, PRs, or releases will be possible after that point. |

Security-critical patches will still be merged during the transition window, but no new features will be accepted.  

— Shane Emmons (current steward) • June 23 2025


# RubyMoney - Money Heuristics

This is a module for heuristic analysis of the string input for the
[money gem](https://github.com/RubyMoney/money). It was formerly part of the gem.

[![Gem Version](https://badge.fury.io/rb/money-heuristics.svg)](https://rubygems.org/gems/money-heuristics)
[![Build Status](https://travis-ci.org/RubyMoney/money-heuristics.svg?branch=master)](https://travis-ci.org/RubyMoney/money-heuristics)
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
