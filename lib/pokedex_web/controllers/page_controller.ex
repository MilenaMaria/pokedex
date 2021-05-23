defmodule PokedexWeb.PageController do
  use PokedexWeb, :controller
  use HTTPoison.Base

  @url "https://pokeapi.co/api/v2"
  @expected_fields ~w(
    name weight height base_experience types
  )

  def index(conn, %{"name" => name} = params) do
    seach_pokemon(conn, name)
  end

  def index(conn, _params) do
    json(conn, "Not Found")
  end

  def seach_pokemon(conn, name) do
    case HTTPoison.get(build_url(name)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response =
          body
          |> Jason.decode!()
          |> Map.take(@expected_fields)

        json(conn, response)

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        conn
        |> put_status(:not_found)
        |> json(body)

      {:error, %{reason: reason}} ->
        json(conn, reason)
    end
  end

  defp build_url(name) do
    @url <> "/pokemon/#{name}"
  end
end
