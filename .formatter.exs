# Files the formatter should leave alone. word_vectors.ex is a hand-laid-out table of
# 50-number GloVe vectors, one word per line; the formatter would put every number on
# its own line (~1,700 extra lines) and make it unreadable.
unformatted = ["lib/algorithms_for_optimization/word_vectors.ex"]

[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs:
    Enum.flat_map(
      ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"],
      &Path.wildcard(&1, match_dot: true)
    ) -- unformatted
]
