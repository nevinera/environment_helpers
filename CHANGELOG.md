# Changelog

## Release 1.6.0

* Remove steep and the rbs types (#41)
* Check the default's type in StringHelpers, preventing
  `ENV.string("FOO", default: 5)` (#38 fixes #33)
* Handle non-numeric values in `ENV.integer` in a more sensible way (#39 fixes #34)
* Split Gemfile out per supported ruby, and commit all of the resulting lockfiles.

## Release 1.5.0

* Add rbs/steep, and enforce types in CI (.rbs file is exported as part
  of the gem) (#28, resolves #21)
* Support env-based customization of the truthy/falsey strings used by
  `ENV.boolean` (#29, resolves #27)
* Update github workflows to use checkout@v4 (which should have no real
  impact on us, aside from staying current). (#30)
* Update README to explain `ENV.array`

## Release 1.4.0

* Drop support for ruby 2.6
* Setup `quiet_quality` through the gemspec
* Setup `markdownlint` and comply with its rules (#25)
* Setup `rspec-cover_it` to enforce test-coverage (#24)

## Release 1.3.0

* Support `ENV.date_time` (#19, resolves #6)

## Release 1.2.1

* Require `set` before loading the gem, since we support rubies before 3.2 (#18)

## Release 1.2.0

* Support `ENV.file_path` returning Pathname objects (#16, resolves #13)

## Release 1.1.0

* Support `ENV.integer_range` (#15, resolves #5)

## Release 1.0.1

* Specify dependencies more tightly (#14)

## Release 1.0.0

(Initial release)
