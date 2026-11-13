# CI/CD Checklist

Getting every push to `main` checked automatically, and only deployed to Railway
when the checks pass. Companion to [LAUNCH_CHECKLIST.md](LAUNCH_CHECKLIST.md).

Owner key: **🤖 Claude** can do it in the repo · **🙋 Andrew** needs your account or a decision · **🤝 Both**

**Pipeline we're aiming for:**
push / PR → GitHub Actions (compile, format, test, audit) → green on `main` → Railway deploys → migrations run → site is live

Last reviewed: 2026-11-12

---

## 1. Make the repo CI-ready

CI is only useful if it can pass. These are failing locally today and would block every run.

- [x] 🤖 Add a `.formatter.exs` (standard Phoenix setup + HEEx formatter). `word_vectors.ex` is
      excluded: formatting would put each of its ~1,650 numbers on its own line
- [x] 🤖 Run `mix format` once across the codebase (whitespace/wrapping only)
- [x] 🤖 Fix the unused-variable warnings in `line_search.ex` (still a stub, args underscored)
      and `simple_bracketing.ex`
- [x] 🤖 `/overview` test now follows `public_topics`: expects a redirect home while Optimization
      is gated, and the rendered page once it's public
- [x] 🤖 Symlink warning: Windows-only and not a compiler warning, so it doesn't fail
      `--warnings-as-errors`; on Linux CI the symlink works
- [x] 🤖 `mix precommit` passes end to end locally (23/23 tests)

## 2. CI workflow (GitHub Actions)

- [x] 🤖 Add `.github/workflows/ci.yml`: runs on pushes to `main`, pull requests, manual trigger,
      and weekly (Mondays 13:00 UTC). A newer push cancels an in-progress run on the same branch
- [x] 🤖 Ubuntu runner, OTP 29.0.1 / Elixir 1.20.1 matching the `Dockerfile` (via `erlef/setup-beam`)
- [x] 🤖 Postgres 17 service container for the test database
- [x] 🤖 Cache `deps/` and `_build/`, keyed on `mix.lock` + OTP/Elixir versions
- [x] 🤖 Steps (all pass locally in this order):
  - [x] `mix deps.get`
  - [x] `mix deps.unlock --check-unused`
  - [x] `mix hex.audit` (fails the build on new security advisories)
  - [x] `mix compile --warnings-as-errors`
  - [x] `mix format --check-formatted`
  - [x] `mix test`
- [x] 🤖 Build minified production assets (tailwind + esbuild, as the Dockerfile does)
- [ ] 🤖 Optional: `docker build` the image on PRs to catch Dockerfile breakage before Railway does
- [ ] 🤝 Push and watch the first run go green. Pushed 2026-11-12 (`29c1930`): GitHub accepted the
      YAML and run #1 started. If it fails, check `setup-beam` finding OTP 29.0.1 / Elixir 1.20.1 first

## 3. Protect `main`

- [ ] 🙋 Decide: push straight to `main`, or work on branches + PRs
- [ ] 🙋 If PRs: GitHub → Settings → Branches → protect `main`, require the CI check to pass before merging
- [ ] 🙋 Even without PRs: CI on `main` still flags breakage after the fact

## 4. CD: deploy to Railway

- [x] 🙋 Railway is connected to `RancorTamer/load-bearing-math` and deploys from `main`
- [x] 🙋 Railway → service → Settings → turn on **Wait for CI**, so a red build never deploys
      (done 2026-11-12; takes effect once `ci.yml` is on GitHub)
- [x] 🤝 Run migrations on every deploy: pre-deploy command `/app/bin/migrate`, set in the
      dashboard and now also in `railway.json`
- [x] 🤖 `GET /health`: 200 `{"status":"ok"}` when Postgres answers `SELECT 1`, 503 otherwise
      (checked locally by stopping Postgres). Outside the browser pipeline (no session) and
      excluded from `force_ssl` in `config/prod.exs`, since Railway checks over plain HTTP
- [x] 🤖 `railway.json` (config-as-code): Dockerfile build, `/app/bin/migrate` pre-deploy,
      health check on `/health` (120s timeout), restart on failure (max 5).
      **These settings override the Railway dashboard** for those fields
- [ ] 🙋 After the next deploy, confirm Railway's deploy view shows the health check passing
- [x] 🙋 Production variables set in Railway (confirmed by Andrew 2026-11-12)

## 5. Keep it healthy

- [x] 🤖 Dependabot (`.github/dependabot.yml`): weekly on Mondays for Hex packages (minor/patch
      grouped into one PR, majors separate) and GitHub Actions. The Docker image's Elixir/OTP
      versions are left out on purpose: they're pinned to match `ci.yml`, so bump both by hand
- [x] 🤖 Scheduled weekly CI run of `mix hex.audit`, so new advisories surface even when nobody pushes
      (the `schedule` trigger in `ci.yml`)
- [ ] 🤖 CI status badge in the README
- [ ] 🙋 GitHub notifications on for failed workflow runs

## 6. Nice to have

- [ ] 🤝 Railway PR preview environments (a temporary copy of the site per pull request)
- [ ] 🤖 `mix credo` for style/consistency checks
- [ ] 🤖 Post-deploy smoke test: hit `/`, `/topics`, `/sitemap.xml` on the live site after each deploy

---

## Done

_(nothing yet)_
