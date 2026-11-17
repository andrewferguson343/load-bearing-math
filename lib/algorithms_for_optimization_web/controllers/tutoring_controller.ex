defmodule AlgorithmsForOptimizationWeb.TutoringController do
  @moduledoc """
  The Tutoring page (offerings + inquiry form, linked from the Services hub), and the private inquiry list.
  The form posts here as a plain HTML form so it works without JavaScript.
  """
  use AlgorithmsForOptimizationWeb, :controller

  alias AlgorithmsForOptimization.{Services, TutoringInquiries}
  alias AlgorithmsForOptimizationWeb.{ClientIP, RateLimiter}

  # Hidden field people never see; any value means a bot filled in every field it found.
  @honeypot_field "company_website"

  def honeypot_field, do: @honeypot_field

  def show(conn, _params) do
    render_page(conn, TutoringInquiries.change())
  end

  def create(conn, %{@honeypot_field => value}) when value not in [nil, ""] do
    # Look successful so the bot has no signal to adapt to, but save nothing.
    thanks(conn)
  end

  def create(conn, params) do
    attrs = Map.get(params, "inquiry", %{})
    rate_limit = Application.fetch_env!(:algorithms_for_optimization, :inquiry_rate_limit)

    # Validate before rate limiting so typo-and-retry doesn't eat into a visitor's allowance;
    # only submissions that would actually be saved count.
    with %Ecto.Changeset{valid?: true} <- TutoringInquiries.change(attrs),
         :ok <- RateLimiter.hit({:tutoring_inquiry, ClientIP.get(conn)}, rate_limit),
         {:ok, _inquiry} <- TutoringInquiries.submit(attrs) do
      thanks(conn)
    else
      {:error, :rate_limited} ->
        conn
        |> put_flash(
          :error,
          "That's a lot of messages at once. Give it a few minutes and try again."
        )
        |> redirect(to: ~p"/tutoring")

      %Ecto.Changeset{} = changeset ->
        conn
        |> put_status(:unprocessable_entity)
        |> render_page(Map.put(changeset, :action, :insert))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render_page(Map.put(changeset, :action, :insert))
    end
  end

  # Private, behind admin basic auth (see the router).
  def index(conn, _params) do
    body =
      TutoringInquiries.list()
      |> Enum.map(fn i ->
        "#{i.inserted_at}\t#{i.name} <#{i.email}>\t#{i.offering || "-"}\n#{i.message}\n"
      end)
      |> Enum.join("\n")

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, body)
  end

  defp render_page(conn, changeset) do
    render(conn, :show,
      offerings: Services.offerings(),
      offering_options: Services.select_options(),
      # The published topics double as proof of expertise (a writing sample, not a syllabus).
      sample_topics: AlgorithmsForOptimization.Topics.visible() |> Enum.take(3),
      form: Phoenix.Component.to_form(changeset, as: :inquiry),
      page_title: "Math and Computer Science Tutoring",
      json_ld: AlgorithmsForOptimizationWeb.SEO.tutoring_service_json_ld(Services.offerings()),
      page_description:
        "Private tutoring in mathematics and computer science, from algebra through differential equations, plus programming, data structures, and algorithms."
    )
  end

  defp thanks(conn) do
    conn
    |> put_flash(:info, "Thanks, your message is in. You'll hear back soon.")
    |> redirect(to: ~p"/tutoring")
  end
end
