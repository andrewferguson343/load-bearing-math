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

- [ ] 🤖 Add a `.formatter.exs` (missing, so `mix format` errors out)
- [ ] 🤖 Run `mix format` once and commit the result as its own commit
- [ ] 🤖 Fix the unused-variable warnings in `line_search.ex` and `simple_bracketing.ex`
      (CI compiles with `--warnings-as-errors`)
- [ ] 🤖 Fix or update the stale `/overview` test (fails because the Optimization topic is gated)
- [ ] 🤖 Silence the Windows-only colocated-assets symlink warning in dev, or confirm it doesn't appear on Linux CI
- [ ] 🤖 Confirm `mix precommit` passes end to end locally

## 2. CI workflow (GitHub Actions)

- [ ] 🤖 Add `.github/workflows/ci.yml`, running on pushes to `main` and on pull requests
- [ ] 🤖 Ubuntu runner, Erlang/OTP + Elixir versions matching the `Dockerfile` (via `erlef/setup-beam`)
- [ ] 🤖 Postgres service container for the test database
- [ ] 🤖 Cache `deps/` and `_build/`, keyed on `mix.lock` + OTP/Elixir versions (keeps runs ~2–4 min)
- [ ] 🤖 Steps:
  - [ ] `mix deps.get`
  - [ ] `mix compile --warnings-as-errors`
  - [ ] `mix format --check-formatted`
  - [ ] `mix deps.unlock --check-unused`
  - [ ] `mix hex.audit` (fails the build on new security advisories)
  - [ ] `mix test`
- [ ] 🤖 Build the production assets (`mix assets.deploy`) so a broken esbuild/tailwind config fails CI, not the deploy
- [ ] 🤖 Optional: `docker build` the image on PRs to catch Dockerfile breakage before Railway does
- [ ] 🤝 Push and watch the first run go green

## 3. Protect `main`

- [ ] 🙋 Decide: push straight to `main`, or work on branches + PRs
- [ ] 🙋 If PRs: GitHub → Settings → Branches → protect `main`, require the CI check to pass before merging
- [ ] 🙋 Even without PRs: CI on `main` still flags breakage after the fact

## 4. CD: deploy to Railway

- [ ] 🙋 Confirm Railway is connected to `RancorTamer/load-bearing-math` and auto-deploys from `main`
- [ ] 🙋 Railway → service → Settings → turn on **Wait for CI**, so a red build never deploys
- [ ] 🤝 Run migrations on every deploy: Railway **pre-deploy command** `/app/bin/migrate`,
      or 🤖 commit a `railway.json` with the build/deploy settings so they live in the repo
- [ ] 🤖 Add a health check endpoint (e.g. `/health`, returns 200 and checks the DB) and
      🙋 point Railway's health check at it, so a broken release doesn't replace a working one
- [ ] 🙋 Confirm production variables are set in Railway (see the hosting item in the launch checklist)

## 5. Keep it healthy

- [ ] 🤖 Add Dependabot (`.github/dependabot.yml`) for Hex packages and GitHub Actions versions, weekly
- [ ] 🤖 Scheduled weekly CI run of `mix hex.audit`, so new advisories surface even when nobody pushes
- [ ] 🤖 CI status badge in the README
- [ ] 🙋 GitHub notifications on for failed workflow runs

## 6. Nice to have

- [ ] 🤝 Railway PR preview environments (a temporary copy of the site per pull request)
- [ ] 🤖 `mix credo` for style/consistency checks
- [ ] 🤖 Post-deploy smoke test: hit `/`, `/topics`, `/sitemap.xml` on the live site after each deploy

---

## Done

_(nothing yet)_
