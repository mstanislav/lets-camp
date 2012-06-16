class UIView
  def url_encode(string)
    return string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
  end
end
