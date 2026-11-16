# Load Bearing Math

[![CI](https://github.com/andrewferguson343/load-bearing-math/actions/workflows/ci.yml/badge.svg)](https://github.com/andrewferguson343/load-bearing-math/actions/workflows/ci.yml)

Short, hands-on walkthroughs of the math holding up the world around us: search engines, rate
limiters, autoscalers, optimization, and more. Every topic is worked out by hand and broken into small
pieces, with the aim of making math less intimidating for anyone curious about it.

The articles are the heart of the site. Alongside them, it offers one-on-one math and computer science
tutoring, and a way for teams to reach out about consulting or engineering work.

Live at **[loadbearingmath.com](https://loadbearingmath.com)**. Built with Phoenix 1.8 and LiveView,
deployed on Railway.

## What's on the site

| Page | What it is |
|---|---|
| `/` | Landing page: featured topic, recently posted, collections, Foundations and Point Loads |
| `/topics` | Every public topic, grouped by collection, with a "Browse by subject" row |
| `/collections/:slug` | One collection's topics (Search & Ranking, Reliability & Control, ...) |
| `/tags/:slug` | Every topic tagged with a subject (Linear Algebra, Calculus, ...) |
| Topic pages | One LiveView per page, e.g. `/cosine-similarity`, `/leaky-bucket` |
| `/services` | Tutoring offerings, prices and an inquiry form |
| `/work-with-me` | Consulting, advisory and employment inquiries |
| `/about`, `/privacy`, `/sources` | About, the privacy policy, and the books and datasets cited |

## How content is organized

Everything about a topic lives in one registry, `lib/algorithms_for_optimization/topics.ex`:

- **Kind:** `:series` (shown as **Article**, possibly multi-part), `:foundation` (a single-page
  primer on the basics), or `:point_load` (a single-page quickie: one equation carrying a lot of weight).
- **Collection:** one home per topic, from `collections.ex`. Collections are themes (what the math is
  used for); Foundations and Point Loads are collections with their own strips on the landing page.
- **Tags:** any number of subjects, from `tags.ex`. Each tag gets its own page.
- **Prerequisites:** foundation ids to read first, shown as "Before you start" in the topic's sidebar.
- **`published_on`:** the date it went public. It orders "Recently posted" and drives the "New"
  badge, but isn't displayed.

Topics are **gated**: only ids listed in `public_topics` (`config/config.exs`) appear on the live site,
in the sitemap and in tests. Dev (`dev_routes`) shows everything. Empty sections (no public
Foundations or Point Loads yet) are hidden on the live site and replaced by a "Dev only" reminder locally.

### Adding a topic

1. Add an entry to `topics.ex` (kind, collection, tags, prerequisites, lessons).
2. Add a LiveView under `lib/algorithms_for_optimization_web/live/` and a route in `router.ex`, inside
   a `live_session` with the `TopicAuth` hook like the others.
3. When it's ready to share, add its id to `public_topics` and set `published_on`.
4. Cite any new books or datasets on the Sources page (`live/sources_live.ex`).

## Getting it running

You'll need Elixir 1.20 and Erlang/OTP 29 (the versions in the `Dockerfile`) and Postgres.

```bash
mix setup       # deps.get + db create/migrate + asset setup/build
mix phx.server  # or `iex -S mix phx.server` if you want a console
```

Then open [`localhost:4000`](http://localhost:4000).

Dev expects Postgres on `localhost` with user/pass `postgres`/`postgres` (see `config/dev.exs`). The easy
way to get one:

```bash
docker run -d --name optimization-algorithms-pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:17
```

On Windows: `.gitattributes` keeps files at LF line endings so `mix format` behaves the same as in CI.
`priv/` is copied into `_build` rather than symlinked, so a changed static file may need a server
restart, as does any change to `config/*.exs`.

## Private pages

Form submissions land in Postgres and are readable behind basic auth (credentials in `config/dev.exs`
locally, `ADMIN_USERNAME`/`ADMIN_PASSWORD` in production; without them these pages 404):

- `/tutoring-inquiries`: messages from the Services form
- `/work-inquiries`: messages from the Work with me form
- `/topic-suggestions`: ideas from the Suggest a topic dialog

Both inquiry forms use a hidden honeypot field and a per-IP rate limit, and only valid submissions
count toward the limit. In dev, preview the branded error pages at `/dev/errors/404` and `/dev/errors/500`.

## Handy commands

```bash
mix precommit        # compile w/ warnings-as-errors, drop unused deps, format, test
mix test             # also creates/migrates the test db for you
mix hex.audit        # check deps for security advisories (CI runs this too)
mix ecto.reset       # drop + recreate the db if you've made a mess of migrations
```

Tailwind and esbuild rebuild automatically in dev via watchers, so no separate terminal is needed.

## Search and sharing

Every page gets a title, a description (trimmed to 155 characters for search results), a canonical
URL and Open Graph tags, from `lib/algorithms_for_optimization_web/seo.ex`. Structured data (JSON-LD)
covers the site, each topic page, the About page (Person) and Services (tutoring with prices).
`/sitemap.xml` and `/robots.txt` are generated per request and only list public pages.

The share card (`priv/static/images/og-image.png`) is rendered from `assets/og/og-image.html`, and the
favicons from `assets/og/icon.html` via `assets/og/build-icons.ps1`. Regenerate them after changing the
logo or brand colors.

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

Email isn't wired up yet: notifications for new inquiries and the privacy contact address are on the
go-live list.

## Keeping an eye on it

- **Health:** `https://loadbearingmath.com/health` returns `{"status":"ok"}` (200) when the app is up and
  can reach Postgres, and 503 when it can't. Point a free uptime checker (UptimeRobot, Better Stack, etc.)
  at it with a keyword check for `"ok"`, so you hear about outages before readers do.
- **Logs:** Railway's deploy and runtime logs.
