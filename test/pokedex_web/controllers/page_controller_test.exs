defmodule PokedexWeb.PageControllerTest do
  use ExUnit.Case, async: true
  use PokedexWeb.ConnCase

  describe "GET /" do
    test "retorna conteudo da rota path" do
      conn = get(build_conn(), "/")

      assert conn.resp_body =~ "Not Found"
    end
  end

  describe "GET /api/pokemon/:name" do
    test "ao realizar busca pelo nome retorna sucesso" do
      conn = get(build_conn(), "/api/pokemon/charizard")

      assert %Plug.Conn{status: 200} = conn
    end

    test "retorna as keys [name weight height base_experience types] no response" do
      conn = get(build_conn(), "/api/pokemon/ditto")

      response = conn.resp_body |> Jason.decode!() |> Map.keys() |> Enum.sort()

      assert response == ["base_experience", "height", "name", "types", "weight"]
    end

    test "retorna 'não encontrado' quando a url for informada incorretamento" do
      conn = get(build_conn(), "/api/pokemon/dog")

      assert %Plug.Conn{status: 404} = conn
    end
  end
end
