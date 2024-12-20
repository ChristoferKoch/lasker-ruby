module DisplayElements
  def print_header
    puts "+-------------------------------------+
|                                     |
|     _              _                |
|    | |    __ _ ___| | _____ _ __    |
|    | |   / _` / __| |/ / _ \\ '__|   |
|    | |__| (_| \\__ \\   <  __/ |      |
|    |_____\\__,_|___/_|\\_\\___|_|      |
|                                     |
|                                     |
+-------------------------------------+"
  end

  def print_menu
    print "\n\tMain Menu\n
\t1. Human vs Human
\t2. Human vs Computer

\tGame type (1 or 2): "
  end

  def print_color_select
    print "\n\tWhat Color Will You Play?\n
\t1. White
\t2. Black

\tColor (1 or 2): "
  end
end
