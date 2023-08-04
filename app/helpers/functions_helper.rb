module FunctionsHelper 

  def empty(x)
    x.nil? || x == ""
  end

  def strcut(str, chars = 3)   
    str[0..(chars-1)]
  end 

end 

