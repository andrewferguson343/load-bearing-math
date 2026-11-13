# Launch Checklist

Everything between "it works on my machine" and a real public site at
**loadbearingmath.com**. Check items off as they land; add notes inline.

Owner key: **🤖 Claude** can do it in the repo · **🙋 Andrew** needs your account, money, or a decision · **🤝 Both**

Last reviewed: 2026-11-12

---

## 1. Launch blockers

- [ ] **Hosting on Railway** 🤝
  DNS is at Porkbun. Checked 2026-11-12: `http://loadbearingmath.com` reaches Railway,
  but **HTTPS fails** because Railway serves its `*.up.railway.app` certificate, not one
  for `loadbearingmath.com`. That means the custom domain isn't attached/verified in Railway yet.
  `www` currently CNAMEs to Porkbun's forwarder and lands on `loadbearingmath-com.l.ink`.
  - [x] 🙋 Host chosen: Railway (builds the repo `Dockerfile`)
  - [x] 🙋 Railway → service → Settings → Networking → **Custom Domain**: add `loadbearingmath.com`
  - [x] 🙋 Porkbun DNS: apex `ALIAS` → `oaqf0kb2.up.railway.app`, plus `_railway-verify` TXT
  - [ ] 🙋 Wait for Railway to show the domain as verified / certificate issued
        (as of 2026-11-12 it still serves the `*.up.railway.app` cert)
  - [ ] 🙋 Railway: also add `www.loadbearingmath.com`; in Porkbun add an explicit `www` CNAME to its
        Railway target. The wildcard `*` CNAME → `uixie.porkbun.com` currently catches `www` and
        forwards it to `loadbearingmath-com.l.ink`; delete the wildcard unless you want other
        subdomains forwarded
  - [ ] 🤖 Redirect `www` → apex in the app (canonical tags already use the apex)
  - [ ] 🙋 Confirm Railway variables: `DATABASE_URL` (from the Railway Postgres), `SECRET_KEY_BASE`,
        `PHX_HOST=loadbearingmath.com`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`
  - [ ] 🤝 Migrations: the release start script doesn't run them. Set Railway's **pre-deploy command**
        to `/app/bin/migrate`, or 🤖 add a `railway.json` that does it
  - [ ] 🤝 Confirm HTTPS works and LiveView connects (`check_origin` already allows both domains)

- [x] **Shrink the JavaScript bundle** 🤖
  esbuild now code-splits (`--format=esm --splitting`, `app.js` loads as a module).
  Plotly and KaTeX are dynamic imports, fetched only when a chart mounts or the page
  contains `$` math. Minified `app.js`: **4.9 MB → 149 KB**; Plotly (4.5 MB) and
  KaTeX (273 KB) are separate chunks loaded on demand.

- [x] **Fix the mobile header** 🤖
  At 720px and below, the brand stays on one line and the nav + theme toggle collapse
  into a menu button with a dropdown panel. The button's `aria-expanded` is the single source of
  truth (CSS `:has()` shows the panel), so it can't desync on fast taps. Closes on outside tap,
  Escape, link tap, or Suggest a Topic. Theme buttons got aria-labels. Checked at 320, 375,
  768 and desktop, light and dark.

- [ ] **Patch Bandit security advisories** 🤖
  `bandit 1.12.5` has several HIGH advisories. Run `mix deps.update bandit`, rerun tests.

- [ ] **Protect the topic suggestion form** 🤖
  `POST /topic-suggestions` is public with no limits.
  - [ ] Max length on suggestion text (changeset validation)
  - [ ] Hidden honeypot field to catch bots
  - [ ] Simple per-IP rate limit

## 2. Should have

- [ ] **Branded 404 / 500 pages** 🤖
  Prod currently shows plain-text "Not Found". Use the site layout with a link back to Topics.

- [ ] **CI on GitHub Actions** 🤖
  Run compile (warnings as errors), format check, and tests on every push. Optionally deploy from `main`.

- [ ] **Get `mix precommit` passing** 🤖
  - [ ] Add a `.formatter.exs` (it's missing, so `mix format` errors)
  - [ ] Fix unused-variable warnings in `line_search.ex` and `simple_bracketing.ex`
  - [ ] Fix or update the stale `/overview` test (fails because that topic is gated)

- [ ] **Privacy-friendly analytics** 🤝
  🙋 Pick one (Plausible, Fathom, or self-hosted Umami); 🤖 wire in the script.
  No cookies, so no consent banner needed.

- [ ] **Uptime monitoring + error tracking** 🤝
  🙋 Sign up for an uptime checker and Sentry or AppSignal; 🤖 add the integration.

- [ ] **Database backups** 🙋
  Confirm automated backups are on for the production Postgres, and do one test restore.

## 3. Nice to have

- [ ] **Social share image** 🤝 1200×630 `og:image` so shared links get a large preview card.
- [ ] **RSS feed** 🤖 for new lessons.
- [ ] **About + contact pages** 🤝 The home page asks readers to report math mistakes but gives no way to reach you.
- [ ] **Content-Security-Policy header** 🤖 Move the inline theme script into `app.js` first.
- [ ] **Accessibility pass** 🤖 Text alternatives for Plotly charts, keyboard focus in the math modals, contrast check in both themes.

---

## Done

- [x] Restyled with its own palette and fonts; Rise8 branding removed
- [x] Renamed to Load Bearing Math (header, titles, favicon, `lbm-` classes)
- [x] SEO: meta descriptions, canonical URLs, Open Graph, JSON-LD, `sitemap.xml`, `robots.txt`
- [x] `/topic-suggestions` list behind basic auth
- [x] GitHub repo renamed to `RancorTamer/load-bearing-math`
- [x] `check_origin` and default host set to `loadbearingmath.com`

## Parked

- [ ] Rant blog: decide whether it's a section of this site, a separate site under your name, or pseudonymous
