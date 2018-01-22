# cli-kit-example

This a simple demo app that shows off how to use [`cli-kit`](https://github.com/shopify/cli-kit) to
construct a simple CLI app.

Suggested reading order:

1. `exe/todo`
1. `lib/todo.rb`
1. everything else under `lib/`

You'll notice that we make heavy use of `autoload`, dependency code is vendored, and we invoke ruby
with `--disable-gems`. These are primary design feature of `cli-kit`, allowing very quick startup,
which is valuable for CLI tools.
