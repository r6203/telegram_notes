defmodule TelegramNotesWeb.Navbar do
  use Surface.LiveComponent

  alias TelegramNotesWeb.Router.Helpers, as: Routes
  alias Surface.Components.LiveRedirect

  prop current_path, :string, default: ""

  def mount(socket) do
    {:ok, assign(socket, current_path: "")}
  end

  def on_mount(:default, _params, _session, socket) do
    socket =
      attach_hook(socket, :current_path, :handle_params, fn _params, url, socket ->
        {:cont, assign(socket, current_path: URI.parse(url).path)}
      end)

    {:cont, socket}
  end

  def render(assigns) do
    ~F"""
    <header class="pt-12">
      <div class="container">
        <div class="flex flex-wrap rounded-2xl bg-gray-100 p-2 shadow-sm space-y-2 sm:space-y-0">
          {#for {href, label} <- links(@socket)}
            <div class="w-full sm:w-1/3 sm:px-2">
              <LiveRedirect to={href}>
                <div class={"rounded-2xl text-lg px-8 py-4 text-center #{active_route_class(href, @current_path)}"}>
                  {label}
                </div>
              </LiveRedirect>
            </div>
          {/for}
        </div>
      </div>
    </header>
    """
  end

  defp active_route_class(href, current_path) do
    if current_path == href do
      "bg-gray-900 text-white font-bold"
    else
      "text-gray-400"
    end
  end

  defp links(socket) do
    [
      {Routes.note_index_path(socket, :index), "Notes"},
      {Routes.note_index_path(socket, :new), "Screenshots"},
      {Routes.note_index_path(socket, :new), "Settings"}
    ]
  end
end
