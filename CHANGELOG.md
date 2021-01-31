# Changelog


## 0.11.0

### Changes

* Add Foodcritic options rule_file, search_gems and include_rules, allows to customize CI with custom ignores and Foodcritic rules.
* Add exclude option to ignore Foodcritic linter.

## 0.2.2

### Bugs fixed

* Don't crash when none of the changes are to cookbooks and roles.

## 0.2.1

### Changes

* [b1cf62](https://github.com/mmozuras/pronto-foodcritic/commit/b1cf62): Bump foodcritic version to '4.0.0'.
* [7aeb64](https://github.com/mmozuras/pronto-foodcritic/commit/7aeb64): Improve performance by reducing the number of linter runs.

### Bugs fixed

* [c88509](https://github.com/mmozuras/pronto-foodcritic/commit/c88509): Don't output warnings for paths that aren't part of the diff.
