# Load Bearing Math

A little Phoenix site where I write up the math behind the systems we build every day: optimization,
rate limiters, autoscalers, search, that kind of thing. Hands-on walkthroughs, worked by hand (so expect
the occasional arithmetic mistake), aimed at anyone who wants to drop in and actually solve something.

Also doubles as my excuse to keep writing Elixir.

## Getting it running

You'll need Elixir ~> 1.17 and a local Postgres instance.

```bash
mix setup       # deps.get + db create/migrate + asset setup/build
mix phx.server  # or `iex -S mix phx.server` if you want a console
```

Then hit [`localhost:4000`](http://localhost:4000).

Dev config expects Postgres on `localhost` with user/pass `postgres`/`postgres` (see `config/dev.exs`).
If your local Postgres doesn't look like that, that's the first thing to fix when `mix setup` yells at you.

## Poking around

- `lib/algorithms_for_optimization_web/live/` — one LiveView per topic walkthrough
- `lib/algorithms_for_optimization/` — the non-web stuff (topic suggestions, line search, etc.)
- Topic suggestions from visitors land in Postgres (`TopicSuggestion` / `TopicSuggestions`), not a tracker
  somewhere, so `mix ecto.setup` needs to have actually run or that feature just silently does nothing.

## Handy commands

```bash
mix precommit        # compile w/ warnings-as-errors, drop unused deps, format, test
mix test              # also creates/migrates the test db for you
mix ecto.reset        # drop + recreate the db if you've made a mess of migrations
```

Tailwind/esbuild assets rebuild automatically in dev via watchers, no separate terminal needed.

## Shipping it

There's a `Dockerfile` and a `rel/` release config for building a production image. Runtime config
(`config/runtime.exs`) wants `DATABASE_URL`, `SECRET_KEY_BASE`, and `PHX_HOST` set wherever it actually
runs. `mix phx.gen.secret` will make you a `SECRET_KEY_BASE` if you need one.
