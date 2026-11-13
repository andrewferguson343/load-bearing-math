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
  - [ ] 🙋 Wait for Railway to show the domain as verified / certificate issued.
        Rechecked 2026-11-12 (Andrew reports hosting done): public DNS (1.1.1.1, 8.8.8.8) and
        the server still serve the `*.up.railway.app` cert, so HTTPS on the apex still fails
  - [ ] 🙋 Railway: also add `www.loadbearingmath.com`; in Porkbun add an explicit `www` CNAME to its
        Railway target. Rechecked 2026-11-12: public DNS still resolves `www` via the wildcard
        `*` CNAME → `uixie.porkbun.com` (forwards to `loadbearingmath-com.l.ink`)
  - [ ] 🤖 Redirect `www` → apex in the app (canonical tags already use the apex)
  - [x] 🙋 Railway variables set: `DATABASE_URL` (from the Railway Postgres), `SECRET_KEY_BASE`,
        `PHX_HOST=loadbearingmath.com`, `ADMIN_USERNAME`, `ADMIN_PASSWORD` (confirmed by Andrew)
  - [x] 🤝 Migrations: Railway **pre-deploy command** `/app/bin/migrate` (confirmed by Andrew)
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

- [x] **Patch dependency security advisories** 🤖
  `mix hex.audit` is clean. Updated: bandit 1.12.5 → 1.14.1 (+ thousand_island 1.6.0),
  ecto 3.14.2 → 3.14.3 (HIGH), phoenix_html 4.3.0 → 4.4.0, decimal 3.1.1 → 3.2.0,
  mint 1.10.1 → 1.11.0, lazy_html 0.1.12 → 0.1.14 (test only).
  Re-run `mix hex.audit` before each deploy (worth adding to CI).

- [x] **Protect the topic suggestion form** 🤖
  - [x] Max 255 characters (changeset + `maxlength`). Longer input used to crash the insert
        with a 500, since the column is `varchar(255)`
  - [x] Off-screen honeypot field (`website`); filled-in posts get the normal "thanks" but aren't saved
  - [x] Per-IP rate limit: 5 posts per 10 minutes (`config :topic_suggestion_rate_limit`), ETS-backed
        `RateLimiter`, no new dependencies. In prod the IP comes from the right-most
        `X-Forwarded-For` entry (Railway's proxy). Revisit if Cloudflare is ever put in front
  - [ ] 🙋 After deploying: submit one suggestion on the live site and check it appears at
        `/topic-suggestions`, to confirm Railway's `X-Forwarded-For` behaves as expected

## 2. Should have

- [x] **Branded 404 / 500 pages** 🤖
  `ErrorHTML` renders standalone pages that only load `app.css`: no LiveView, JS, DB or root
  layout, so the 500 page still renders when the normal page stack is what broke. Theme
  follows the system setting; pages are `noindex`. Other statuses keep the plain-text default.
  Preview in dev at `/dev/errors/404` and `/dev/errors/500` (real errors in dev show the debug page).

- [ ] **CI/CD** 🤝
  Tracked in detail in [CI_CD_CHECKLIST.md](CI_CD_CHECKLIST.md): getting `mix precommit`
  passing, the GitHub Actions workflow, protecting `main`, and gating Railway deploys on CI.

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
