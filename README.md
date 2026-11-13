# Load Bearing Math

[![CI](https://github.com/andrewferguson343/load-bearing-math/actions/workflows/ci.yml/badge.svg)](https://github.com/andrewferguson343/load-bearing-math/actions/workflows/ci.yml)

A little Phoenix site where I write up the math behind the systems we build every day: optimization,
rate limiters, autoscalers, search, that kind of thing. Hands-on walkthroughs, worked by hand (so expect
the occasional arithmetic mistake), aimed at anyone who wants to drop in and actually solve something.

Live at **[loadbearingmath.com](https://loadbearingmath.com)**. Also doubles as my excuse to keep writing Elixir.

## Getting it running

You'll need Elixir 1.20 / Erlang/OTP 29 (the versions in the `Dockerfile`) and a local Postgres.

```bash
mix setup       # deps.get + db create/migrate + asset setup/build
mix phx.server  # or `iex -S mix phx.server` if you want a console
```

Then hit [`localhost:4000`](http://localhost:4000).

Dev config expects Postgres on `localhost` with user/pass `postgres`/`postgres` (see `config/dev.exs`).
The easy way to get one:

```bash
docker run -d --name optimization-algorithms-pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:17
```

## Poking around

- `lib/algorithms_for_optimization_web/live/`: one LiveView per topic walkthrough
- `lib/algorithms_for_optimization/topics.ex`: the topic registry. Topics only show publicly once they're
  in `public_topics` (`config/config.exs`); dev shows everything
- `lib/algorithms_for_optimization/`: the non-web stuff (topic suggestions, bracketing, word vectors, etc.)
- Topic suggestions from visitors land in Postgres. Read them at `/topic-suggestions` (basic auth:
  `admin`/`admin` in dev, `ADMIN_USERNAME`/`ADMIN_PASSWORD` in prod)
- Error page previews in dev: `/dev/errors/404`, `/dev/errors/500`

## Handy commands

```bash
mix precommit        # compile w/ warnings-as-errors, drop unused deps, format, test
mix test             # also creates/migrates the test db for you
mix hex.audit        # check deps for security advisories (CI runs this too)
mix ecto.reset       # drop + recreate the db if you've made a mess of migrations
```

Tailwind/esbuild assets rebuild automatically in dev via watchers, no separate terminal needed.

## How changes ship

`main` is protected: changes go in on a branch, through a pull request, and merge once CI is green.
The full workflow is in [AGENTS.md](AGENTS.md).

1. **CI** (`.github/workflows/ci.yml`) runs on every push, PR and weekly: unused-deps check, `mix hex.audit`,
   compile with warnings as errors, format check, tests against Postgres, and a production asset build.
2. **Railway** deploys `main` once CI passes ("Wait for CI"). `railway.json` builds the `Dockerfile`,
   runs `/app/bin/migrate` before each deploy, and only switches traffic once `GET /health` returns 200.
3. **Dependabot** opens weekly update PRs for Hex packages and GitHub Actions.

Production needs these Railway variables: `DATABASE_URL`, `SECRET_KEY_BASE` (`mix phx.gen.secret` makes one),
`PHX_HOST=loadbearingmath.com`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`.

## Keeping an eye on it

- **Health:** `https://loadbearingmath.com/health` returns `{"status":"ok"}` (200) when the app is up and
  can reach Postgres, and 503 when it can't. Point a free uptime checker (UptimeRobot, Better Stack, etc.)
  at it with a keyword check for `"ok"`, so you hear about outages before readers do.
- **Logs:** Railway's deploy and runtime logs.
