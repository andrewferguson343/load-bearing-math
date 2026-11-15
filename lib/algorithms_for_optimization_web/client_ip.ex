defmodule AlgorithmsForOptimizationWeb.ClientIP do
  @moduledoc "The visitor's IP address, for per-visitor rate limiting of public forms."

  import Plug.Conn, only: [get_req_header: 2]

  # Behind Railway's proxy, conn.remote_ip is the proxy, not the visitor. Railway appends the
  # visitor's address to X-Forwarded-For, so the right-most entry is the one it actually saw
  # (entries further left are client-supplied and spoofable). If another proxy such as
  # Cloudflare is ever put in front of Railway, this needs revisiting.
  def get(conn) do
    trust_forwarded? =
      Application.get_env(:algorithms_for_optimization, :trust_x_forwarded_for, false)

    forwarded =
      if trust_forwarded? do
        conn
        |> get_req_header("x-forwarded-for")
        |> Enum.flat_map(&String.split(&1, ","))
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
        |> List.last()
      end

    forwarded || conn.remote_ip |> :inet.ntoa() |> to_string()
  end
end
