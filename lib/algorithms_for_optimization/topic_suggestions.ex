defmodule AlgorithmsForOptimization.TopicSuggestions do
  @moduledoc """
  Captures topic suggestions from site visitors. Appends to a flat file in
  priv/ since there's nothing here that needs a database: read the file to
  see what people have suggested.
  """

  defp path do
    Path.join(Application.app_dir(:algorithms_for_optimization, "priv"), "topic_suggestions.txt")
  end

  def submit(suggestion) when is_binary(suggestion) do
    trimmed = String.trim(suggestion)

    if trimmed != "" do
      line = "#{DateTime.utc_now() |> DateTime.to_iso8601()}\t#{trimmed}\n"
      File.write!(path(), line, [:append, :utf8])
      :ok
    else
      :error
    end
  end

  @doc "All suggestions, newest first, as {timestamp, text} tuples."
  def list do
    case File.read(path()) do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)
        |> Enum.map(fn line ->
          case String.split(line, "\t", parts: 2) do
            [timestamp, text] -> {timestamp, text}
            [text] -> {"", text}
          end
        end)
        |> Enum.reverse()

      {:error, :enoent} ->
        []
    end
  end
end
