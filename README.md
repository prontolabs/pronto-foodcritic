# Pronto runner for Food Critic

[![Code Climate](https://codeclimate.com/github/mmozuras/pronto-foodcritic.png)](https://codeclimate.com/github/mmozuras/pronto-foodcritic)
[![Build Status](https://secure.travis-ci.org/mmozuras/pronto-foodcritic.svg)](http://travis-ci.org/mmozuras/pronto-foodcritic)
[![Gem Version](https://badge.fury.io/rb/pronto-foodcritic.png)](http://badge.fury.io/rb/pronto-foodcritic)
[![Dependency Status](https://gemnasium.com/mmozuras/pronto-foodcritic.png)](https://gemnasium.com/mmozuras/pronto-foodcritic)

Pronto runner for [Food Critic](https://github.com/acrmp/foodcritic), lint tool for chef. [What is Pronto?](https://github.com/mmozuras/pronto)

## Configuration

You can provide several Food Critic options via `.pronto.yml`:

```yml
foodcritic:
  # Like CLI option --search-gems
  search_gems: true

  # Like CLI option --include, add custom rules to your CI
  include_rules:
    - lib/foodcritic/rules

  # Like CLI option --rule-file
  rule_file: .foodcritic-ci

  # File GLOBs to ignore, matching files won't be passed to Food Critic
  exclude:
    - '**/test/integration/**/*_spec.rb'
```

## Note

Currently, naively uses path to determine if a file is a cookbook or a role configuration.
