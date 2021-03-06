Code.require_file "../../test_helper.exs", __DIR__

defmodule Mix.SCM.GitTest do
  use MixTest.Case, async: true

  test "formats the lock" do
    assert Mix.SCM.Git.format_lock(lock()) == "abcdef0"
    assert Mix.SCM.Git.format_lock(lock(branch: "master")) == "abcdef0 (branch: master)"
    assert Mix.SCM.Git.format_lock(lock(tag: "v0.12.0"))   == "abcdef0 (tag: v0.12.0)"
    assert Mix.SCM.Git.format_lock(lock(ref: "abcdef0"))   == "abcdef0 (ref)"
  end

  test "considers to dep equals if the have the same git and the same opts" do
    assert Mix.SCM.Git.equal?([git: "foo"], [git: "foo"])
    refute Mix.SCM.Git.equal?([git: "foo"], [git: "bar"])

    assert Mix.SCM.Git.equal?([git: "foo", branch: "master"], [git: "foo", branch: "master"])
    refute Mix.SCM.Git.equal?([git: "foo", branch: "master"], [git: "foo", branch: "other"])
  end

  test "lock should not be taken into account when considering deps equal as the lock is shared" do
    assert Mix.SCM.Git.equal?([git: "foo", lock: 1], [git: "foo", lock: 2])
  end

  defp lock(opts \\ []) do
    [lock: {:git, "/repo", "abcdef0123456789", opts}]
  end
end
