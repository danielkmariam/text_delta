defmodule TextDelta.AttributesTest do
  use ExUnit.Case
  doctest TextDelta.Attributes
  alias TextDelta.Attributes

  describe "compose" do
    @attributes %{bold: true, color: "red"}

    test "from nothing" do
      assert Attributes.compose(%{}, @attributes) == @attributes
    end

    test "to nothing" do
      assert Attributes.compose(@attributes, %{}) == @attributes
    end

    test "nothing with nothing" do
      assert Attributes.compose(%{}, %{}) == %{}
    end

    test "with new attribute" do
      assert Attributes.compose(@attributes, %{italic: true}) == %{
        bold: true,
        italic: true,
        color: "red"
      }
    end

    test "with overwriten attribute" do
      assert Attributes.compose(@attributes, %{bold: false, color: "blue"}) == %{
        bold: false,
        color: "blue"
      }
    end

    test "with attribute removed" do
      assert Attributes.compose(@attributes, %{bold: nil}) == %{color: "red"}
    end

    test "with all attributes removed" do
      assert Attributes.compose(@attributes, %{bold: nil, color: nil}) == %{}
    end

    test "with removal of inexistent element" do
      assert Attributes.compose(@attributes, %{italic: nil}) == @attributes
    end
  end

  describe "transform" do
    @lft %{bold: true, color: "red", font: nil}
    @rgt %{color: "blue", font: "serif", italic: true}

    test "from nothing" do
      assert Attributes.transform(%{}, @rgt, :right) == @rgt
    end

    test "to nothing" do
      assert Attributes.transform(@lft, %{}, :right) == %{}
    end

    test "nothing to nothing" do
      assert Attributes.transform(%{}, %{}, :right) == %{}
    end

    test "left to right with priority" do
      assert Attributes.transform(@lft, @rgt, :left) == %{italic: true}
    end

    test "left to right without priority" do
      assert Attributes.transform(@lft, @rgt, :right) == @rgt
    end
  end
end
