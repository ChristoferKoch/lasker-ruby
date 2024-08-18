module Spacing
  # Add spacing to make display easier to read
  def line_spacing(unspaced_string)
    string_arr = unspaced_string.split('')
    count = string_arr.count
    i = 1

    while i < count do
      string_arr.insert(i, ' ')
      i += 2
      count += 1
    end

    return string_arr.join
  end
end
