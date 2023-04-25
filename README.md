# EnvironmentHelpers
This gem adds a set of convenience helpers to `ENV`, allowing you to access environment variables
in a more structures and consistent way. Have you seen any line like these?

```
enable_bar = ENV.fetch("ENABLE_BAR", "false") == "true"
foo_count = ENV.fetch("FOO_TOTAL", "100").to_i
```

This works okay! And it's not really that complicated, working out what's going on here isn't
that difficult. How about this?

```
enable_foo = ENV.fetch("ENABLE_FOO", "false") != "true"
```

That.. looks very similar, but means the opposite thing. Also not that tricky. You don't start
to _wish_ for a tool like EnvironmentHelpers until these constructions get complex and compounded.
But.. if you're using a 12-factor style of configuration, you probably have these ENV-fetches
sprinkled _everywhere_, so making them moderately clearer or simpler can pay off fairly quickly.

## Installation

```
gem "environment_helper"
```

There's not much to it - add the gem to your gemfile and when it's loaded it'll add some extra
methods onto `ENV` for your use.

## Usage

```
ENV.string("APP_NAME", default: "local")
ENV.symbol("BUSINESS_DOMAIN", default: :engineering, required: true)
ENV.boolean("ENABLE_FEATURE_FOO", default: false)
ENV.integer("MAX_THREAD_COUNT", default: 5)
ENV.date("SCHEDULED_DATE", required: true, format: "%Y-%m-%d")
```

Each of the supplied methods takes a positional parameter for the name of the environment variable,
and then two optional named parameters `default` and `required` (there's no point in supplying
both, but nothing stops you from doing so). The `default` value is the value used if the variable
isn't present in the environment. If `required` is set to a truthy value, then if the variable isn't
present in the environment, an `EnvironmentHelpers::MissingVariableError` is raised.

The available methods added to `ENV`:
* `string` - environment values are already strings, so this is the simplest of the methods.
* `symbol` - produces a symbol, and enforces that the default value is either `nil` or a Symbol.
* `boolean` - produces `nil`, `true`, or `false` (and only allows those as defaults). Supports..
  a fair variety of strings to map onto those boolean value, though you should probably just use
  "true" and "false" really. If you specify `required: true` and get a value like "maybe?", it'll
  raise an `EnvironmentHelpers::InvalidBooleanText` exception.
* `integer` - produces an integer from the environment variable, by calling `to_i` on it (if it's
  present). Note that this means that providing a value like "hello" means you'll get `0`, since
  that's what ruby does when you call `"hello".to_i`.
* `date` - produces a `Date` object, using `Date.strptime`. The default format string is `%Y-%m-%d`,
  which would parse a date like `2023-12-25`. It will handle invalid values (or format strings) like
  the variable not being present, though if it's specified as `required`, you will see a different
  exception in each case.
