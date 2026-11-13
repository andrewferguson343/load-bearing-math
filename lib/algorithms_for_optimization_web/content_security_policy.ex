defmodule AlgorithmsForOptimizationWeb.ContentSecurityPolicy do
  @moduledoc """
  Sets a Content-Security-Policy header on browser responses (plugged in the router's
  `:browser` pipeline).

  Scripts are locked down: only same-origin files (app.js and its lazy chunks) plus inline
  scripts carrying this request's nonce run. The one inline script, the theme loader in
  root.html.heex, gets `nonce={@csp_nonce}` because it has to run before first paint to avoid a
  light/dark flash. JSON-LD `<script type="application/ld+json">` blocks are data, not code,
  so CSP doesn't apply to them.

  Styles allow `'unsafe-inline'`: page-level `<style>` blocks, KaTeX, Plotly and LiveView's
  JS transitions all set inline styles, and inline CSS is low risk once scripts are locked down.
  """
  @behaviour Plug

  import Plug.Conn

  @nonce_bytes 18

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    nonce = @nonce_bytes |> :crypto.strong_rand_bytes() |> Base.encode64(padding: false)

    conn
    |> assign(:csp_nonce, nonce)
    |> put_resp_header("content-security-policy", policy(conn, nonce))
  end

  @doc false
  def policy(conn, nonce) do
    [
      "default-src 'self'",
      "script-src 'self' 'nonce-#{nonce}'",
      "style-src 'self' 'unsafe-inline'",
      "img-src 'self' data: blob:",
      "font-src 'self' data:",
      # 'self' covers same-origin websockets in current browsers; the explicit ws/wss
      # entries are for older ones (LiveView connects over /live).
      "connect-src 'self' #{websocket_origins(conn)}",
      "object-src 'none'",
      "base-uri 'self'",
      "form-action 'self'",
      "frame-ancestors 'none'"
    ]
    |> Enum.join("; ")
  end

  defp websocket_origins(conn) do
    host =
      if conn.port in [80, 443] or is_nil(conn.port),
        do: conn.host,
        else: "#{conn.host}:#{conn.port}"

    "ws://#{host} wss://#{host}"
  end
end
