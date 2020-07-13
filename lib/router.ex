defmodule LoadBalancer.Router do
  use Plug.Router
  require Logger

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  post "/upload" do
    LoadBalancer.Producer.upload_image(conn)

    receive do
      {:ok, filePath} ->
        conn
        |> Plug.Conn.send_resp(201, filePath)

      {:error, error} ->
        Logger.error(inspect(error))

        conn
        |> Plug.Conn.send_resp(500, "Something went wrong")
    end
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
