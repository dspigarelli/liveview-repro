defmodule LiveviewReproWeb.ReproLive.Index do
  use LiveviewReproWeb, :live_view
  use Phoenix.HTML

  use Ecto.Schema

  @state_options [:wa, :ca, :or, :nv]
  embedded_schema do
    field(:state, Ecto.Enum, values: @state_options)
    field(:name, :string)
    field(:street, :string)
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :state_options, @state_options)

    ~H"""
    <.form let={f} for={@changeset} id="my-form" phx-change="validate" phx-save="validate">

      <%= label f, :name %>
      <%= text_input f, :name, class: derive_input_classes(f, :name) %>
      <%= error_tag f, :name %>

      <%= label f, :street %>
      <%= text_input f, :street, class: derive_input_classes(f, :street) %>
      <%= error_tag f, :street %>

      <%= label f, :state %>
      <%= select f, :state, [[key: "", value: ""] | @state_options |> Enum.map(&([key: &1, value: &1]))], class: derive_input_classes(f, :state) %>
      <%= error_tag f, :state %>

      <%= submit "Save" %>
    </.form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :changeset, form_changeset(%__MODULE__{}, %{}))}
  end

  @impl true
  def handle_event("validate", %{"index" => params}, socket) do
    changeset =
      %__MODULE__{}
      |> form_changeset(params)
      |> Map.put(:action, :validate)

    {
      :noreply, socket
      |> assign(:changeset, changeset)
    }
  end

  defp form_changeset(%__MODULE__{} = model, params) do
    model
    |> Ecto.Changeset.cast(params, [:state, :name, :street])
    |> Ecto.Changeset.validate_required([:state, :name, :street])
  end

  defp derive_input_classes(form, field) do
    cond do
      form.errors[field] ->
        "border-danger"

      true ->
        ""
    end
  end
end
