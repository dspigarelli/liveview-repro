defmodule LiveviewReproWeb.ReproLiveTest do
  use LiveviewReproWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveviewRepro.TestFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_repro(_) do
    repro = repro_fixture()
    %{repro: repro}
  end

  describe "Index" do
    setup [:create_repro]

    test "lists all repro", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.repro_index_path(conn, :index))

      assert html =~ "Listing Repro"
    end

    test "saves new repro", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.repro_index_path(conn, :index))

      assert index_live |> element("a", "New Repro") |> render_click() =~
               "New Repro"

      assert_patch(index_live, Routes.repro_index_path(conn, :new))

      assert index_live
             |> form("#repro-form", repro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repro-form", repro: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repro_index_path(conn, :index))

      assert html =~ "Repro created successfully"
    end

    test "updates repro in listing", %{conn: conn, repro: repro} do
      {:ok, index_live, _html} = live(conn, Routes.repro_index_path(conn, :index))

      assert index_live |> element("#repro-#{repro.id} a", "Edit") |> render_click() =~
               "Edit Repro"

      assert_patch(index_live, Routes.repro_index_path(conn, :edit, repro))

      assert index_live
             |> form("#repro-form", repro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repro-form", repro: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repro_index_path(conn, :index))

      assert html =~ "Repro updated successfully"
    end

    test "deletes repro in listing", %{conn: conn, repro: repro} do
      {:ok, index_live, _html} = live(conn, Routes.repro_index_path(conn, :index))

      assert index_live |> element("#repro-#{repro.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#repro-#{repro.id}")
    end
  end

  describe "Show" do
    setup [:create_repro]

    test "displays repro", %{conn: conn, repro: repro} do
      {:ok, _show_live, html} = live(conn, Routes.repro_show_path(conn, :show, repro))

      assert html =~ "Show Repro"
    end

    test "updates repro within modal", %{conn: conn, repro: repro} do
      {:ok, show_live, _html} = live(conn, Routes.repro_show_path(conn, :show, repro))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Repro"

      assert_patch(show_live, Routes.repro_show_path(conn, :edit, repro))

      assert show_live
             |> form("#repro-form", repro: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#repro-form", repro: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repro_show_path(conn, :show, repro))

      assert html =~ "Repro updated successfully"
    end
  end
end
