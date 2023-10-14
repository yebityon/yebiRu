class CustomIO
  def read_line
    gets.chomp
  end

  def read_int
    read_line.to_i
  end

  def read_carray
    read_line.split(' ')
  end
end
