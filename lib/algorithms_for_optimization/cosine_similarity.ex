defmodule AlgorithmsForOptimization.CosineSimilarity do
  def dot_product(vector1, vector2) do
    # take both lists, start at index 0, perform x*y
    # This is actually the whole dot product between the two vectors
    Enum.zip_reduce(vector1, vector2, 0, fn x,y,acc -> acc + x * y end )
  end

  def magnitude(vector) do
    ## squrt a1^2 + a2^2 ...
    sum = Enum.reduce(vector, 0, fn x,acc -> acc+x*x end)
    :math.sqrt(sum)
  end

  @spec cosine_similarity(list(), list()) :: float()
  ## the exact same formula from our example
  def cosine_similarity(a, b) do
    dotp = dot_product(a, b)
    magA = magnitude(a)
    magB = magnitude(b)
    dotp / (magA * magB)
  end
end
