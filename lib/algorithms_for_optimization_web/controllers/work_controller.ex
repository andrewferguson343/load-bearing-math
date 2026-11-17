defmodule AlgorithmsForOptimizationWeb.WorkController do
  @moduledoc """
  The Work with me page (consulting, advice and employment inquiries) and the private
  inquiry list. Mirrors ServicesController: plain HTML form, honeypot, per-IP rate limit.
  """
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.WorkInquiries
  alias AlgorithmsForOptimizationWeb.{ClientIP, RateLimiter}

  # Hidden field people never see; any value means a bot filled in every field it found.
  @honeypot_field "company_website"

  def honeypot_field, do: @honeypot_field

  def show(conn, _params), do: render_page(conn, WorkInquiries.change())

  def create(conn, %{@honeypot_field => value}) when value not in [nil, ""] do
    # Look successful so the bot has no signal to adapt to, but save nothing.
    thanks(conn)
  end

  def create(conn, params) do
    attrs = Map.get(params, "work", %{})
    rate_limit = Application.fetch_env!(:algorithms_for_optimization, :inquiry_rate_limit)

    # Validate before rate limiting so fixing a typo doesn't use up the allowance.
    with %Ecto.Changeset{valid?: true} <- WorkInquiries.change(attrs),
         :ok <- RateLimiter.hit({:work_inquiry, ClientIP.get(conn)}, rate_limit),
         {:ok, _inquiry} <- WorkInquiries.submit(attrs) do
      thanks(conn)
    else
      {:error, :rate_limited} ->
        conn
        |> put_flash(
          :error,
          "That's a lot of messages at once. Give it a few minutes and try again."
        )
        |> redirect(to: ~p"/work-with-me")

      %Ecto.Changeset{} = changeset ->
        invalid(conn, changeset)

      {:error, %Ecto.Changeset{} = changeset} ->
        invalid(conn, changeset)
    end
  end

  # Private, behind admin basic auth (see the router).
  def index(conn, _params) do
    body =
      WorkInquiries.list()
      |> Enum.map(fn i ->
        "#{i.inserted_at}\t#{i.name} <#{i.email}>\t#{i.organization || "-"}\n#{i.message}\n"
      end)
      |> Enum.join("\n")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end

  defp invalid(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render_page(Map.put(changeset, :action, :insert))
  end

  defp render_page(conn, changeset) do
    render(conn, :show,
      form: Phoenix.Component.to_form(changeset, as: :work),
      page_title: "Work with me",
      page_description:
        "Consulting, engineering advice and select full-time roles in aerospace, space systems, systems engineering, and large-scale systems integration."
    )
  end

  defp thanks(conn) do
    conn
    |> put_flash(:info, "Thanks. I read every message and will be in touch if it's a fit.")
    |> redirect(to: ~p"/work-with-me")
  end
end
