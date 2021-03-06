defmodule Wallaby.XPath do
  @type query :: String.t
  @type xpath :: String.t
  @type name  :: query
  @type id    :: query
  @type label :: query

  import Wallaby.XPath.Builder
  import Wallaby.XPath.Render

  @doc """
  XPath for links
  this xpath is gracious ripped from capybara via
  https://github.com/jnicklas/xpath/blob/master/lib/xpath/html.rb
  """
  def link(lnk) do
    ".//a[./@href][(((./@id = '#{lnk}' or contains(normalize-space(string(.)), '#{lnk}')) or contains(./@title, '#{lnk}')) or .//img[contains(./@alt, '#{lnk}')])]"
  end

  def radio_button(query) do
    ".//input[./@type = 'radio'][(((./@id = '#{query}' or ./@name = '#{query}') or ./@placeholder = '#{query}') or ./@id = //label[contains(normalize-space(string(.)), '#{query}')]/@for)] | .//label[contains(normalize-space(string(.)), '#{query}')]//.//input[./@type = 'radio']"
  end

  @doc """
  Match any `input` or `textarea` that can be filled with text.
  Excludes any inputs with types of `submit`, `image`, `radio`, `checkbox`,
  `hidden`, or `file`.
  """
  def fillable_field(query) when is_binary(query) do
    ".//*[self::input | self::textarea][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'radio' or ./@type = 'checkbox' or ./@type = 'hidden' or ./@type = 'file')][(((./@id = '#{query}' or ./@name = '#{query}') or ./@placeholder = '#{query}') or ./@id = //label[contains(normalize-space(string(.)), '#{query}')]/@for)] | .//label[contains(normalize-space(string(.)), '#{query}')]//.//*[self::input | self::textarea][not(./@type = 'submit' or ./@type = 'image' or ./@type = 'radio' or ./@type = 'checkbox' or ./@type = 'hidden' or ./@type = 'file')]"
  end

  def checkbox(query) do
    ".//input[./@type = 'checkbox'][(((./@id = '#{query}' or ./@name = '#{query}') or ./@placeholder = '#{query}') or ./@id = //label[contains(normalize-space(string(.)), '#{query}')]/@for)] | .//label[contains(normalize-space(string(.)), '#{query}')]//.//input[./@type = 'checkbox']"
  end

  defp fillable_fields do
    ["textarea", "input"]
  end

  defp unfillable_fields do
    attr("type", ["checkbox", "submit", "button"])
  end

  defp field_locator(query) do
    any([attr("id", query), attr("name", query), attr("placeholder", query), ])
  end
end
