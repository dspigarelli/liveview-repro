defmodule LiveviewReproWeb.RepoLiveTest do
  use LiveviewReproWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveviewRepro.TestFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_repo(_) do
    repo = repo_fixture()
    %{repo: repo}
  end

  describe "Index" do
    setup [:create_repo]

    test "lists all repo", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.repo_index_path(conn, :index))

      assert html =~ "Listing Repo"
    end

    test "saves new repo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.repo_index_path(conn, :index))

      assert index_live |> element("a", "New Repo") |> render_click() =~
               "New Repo"

      assert_patch(index_live, Routes.repo_index_path(conn, :new))

      assert index_live
             |> form("#repo-form", repo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repo-form", repo: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repo_index_path(conn, :index))

      assert html =~ "Repo created successfully"
    end

    test "updates repo in listing", %{conn: conn, repo: repo} do
      {:ok, index_live, _html} = live(conn, Routes.repo_index_path(conn, :index))

      assert index_live |> element("#repo-#{repo.id} a", "Edit") |> render_click() =~
               "Edit Repo"

      assert_patch(index_live, Routes.repo_index_path(conn, :edit, repo))

      assert index_live
             |> form("#repo-form", repo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#repo-form", repo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repo_index_path(conn, :index))

      assert html =~ "Repo updated successfully"
    end

    test "deletes repo in listing", %{conn: conn, repo: repo} do
      {:ok, index_live, _html} = live(conn, Routes.repo_index_path(conn, :index))

      assert index_live |> element("#repo-#{repo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#repo-#{repo.id}")
    end
  end

  describe "Show" do
    setup [:create_repo]

    test "displays repo", %{conn: conn, repo: repo} do
      {:ok, _show_live, html} = live(conn, Routes.repo_show_path(conn, :show, repo))

      assert html =~ "Show Repo"
    end

    test "updates repo within modal", %{conn: conn, repo: repo} do
      {:ok, show_live, _html} = live(conn, Routes.repo_show_path(conn, :show, repo))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Repo"

      assert_patch(show_live, Routes.repo_show_path(conn, :edit, repo))

      assert show_live
             |> form("#repo-form", repo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#repo-form", repo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.repo_show_path(conn, :show, repo))

      assert html =~ "Repo updated successfully"
    end
  end
end
