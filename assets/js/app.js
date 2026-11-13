// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/algorithms_for_optimization"
import topbar from "../vendor/topbar"

// KaTeX (~275 KB) is only fetched when a page actually contains math delimiters.
let katexPromise = null
const loadKatexAutoRender = () => {
  katexPromise ||= import("../vendor/katex-auto-render.min.js").then(mod => mod.default || mod)
  return katexPromise
}

// Plotly is ~4.5 MB, so it's split into its own chunk and only fetched the
// first time a page actually mounts a chart. Later charts reuse the same promise.
let plotlyPromise = null
const loadPlotly = () => {
  plotlyPromise ||= import("../vendor/plotly.min.js").then(mod => mod.default || mod)
  return plotlyPromise
}

// Renders a Plotly chart from data/layout passed as JSON in data attributes.
//
// Usage in a LiveView template:
//
//     <div
//       id="my-chart"
//       phx-hook="PlotlyChart"
//       data-plotly-data={Jason.encode!(traces)}
//       data-plotly-layout={Jason.encode!(layout)}
//     />
//
// Push new data by re-rendering the assigns that feed those attributes;
// `updated()` will redraw the chart with Plotly.react (no full remount).
const Hooks = {
  PlotlyChart: {
    mounted() {
      this.draw()
    },
    updated() {
      this.draw()
    },
    async draw() {
      const data = JSON.parse(this.el.dataset.plotlyData || "[]")
      const layout = JSON.parse(this.el.dataset.plotlyLayout || "{}")
      const Plotly = await loadPlotly()
      // The hook may have been removed (live navigation) while Plotly was loading.
      if (!this.el.isConnected) return
      await Plotly.react(this.el, data, layout, {responsive: true})
      // The chart's description lives in the container's aria-label (role="figure"), so hide
      // Plotly's SVG internals (tick labels, paths) from screen readers instead of reading them out.
      // The toolbar buttons stay reachable.
      this.el.querySelectorAll(".main-svg, .gl-container").forEach(el => el.setAttribute("aria-hidden", "true"))
    },
  },

  // Renders LaTeX written directly in your HEEx markup, e.g.:
  //
  //     <p>The gradient is $\nabla f(x)$, or in block form: $$\nabla f(x) = 0$$</p>
  //
  // Attached at the <main> level in the app layout, so it re-scans and
  // re-renders any time a LiveView patches the page (including live
  // navigation between lesson pages).
  KatexRender: {
    mounted() {
      this.render()
    },
    updated() {
      this.render()
    },
    async render() {
      if (!this.el.textContent.includes("$")) return
      const renderMathInElement = await loadKatexAutoRender()
      if (!this.el.isConnected) return
      renderMathInElement(this.el, {
        delimiters: [
          {left: "$$", right: "$$", display: true},
          {left: "$", right: "$", display: false},
        ],
        throwOnError: false,
      })
    },
  },
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...Hooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

