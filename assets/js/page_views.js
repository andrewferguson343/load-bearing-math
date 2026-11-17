// First-party page view counting. Sends the path (and, on a full page load, the referrer)
// to /api/read, which keeps nothing but daily per-page counts. No cookies, no IDs, no third
// parties. See AlgorithmsForOptimization.Analytics on the server.
//
// One view is sent on each full page load and on each LiveView navigation to a different path,
// so query-string patches on the same page and reconnects don't double count.

const optedOut = () =>
  navigator.globalPrivacyControl === true ||
  navigator.doNotTrack === "1" ||
  window.doNotTrack === "1"

let lastPath = null

const send = (referrer) => {
  const path = window.location.pathname
  if (path === lastPath) return
  lastPath = path

  fetch("/api/read", {
    method: "POST",
    headers: {"content-type": "application/json"},
    body: JSON.stringify({path, referrer}),
    keepalive: true,
    credentials: "omit",
  }).catch(() => {})
}

export const trackPageViews = () => {
  if (optedOut()) return

  // The full page load: the only time document.referrer can point outside the site.
  send(document.referrer || "")

  // LiveView navigations change the URL without a page load.
  window.addEventListener("phx:page-loading-stop", () => send(""))
}
