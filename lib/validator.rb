class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
      
      sudoku_row_file = self.get_sudoku_row_file(@puzzle_string)
      
      if sudoku_numbers_valid(sudoku_row_file)
        sudoku_column_file = get_sudoku_columns(sudoku_row_file)
        sudoku_grid_file = get_sudoku_grid_file(sudoku_row_file)

        rows_valid = are_lines_valid(sudoku_row_file)
        columns_valid = are_lines_valid(sudoku_column_file)
        grid_valid = are_lines_valid(sudoku_grid_file)
        
        sudoku_is_complete = is_sudoku_complete(sudoku_row_file)
        sudoku_is_valid = rows_valid && columns_valid && grid_valid ? true : false

        if sudoku_is_complete && sudoku_is_valid
          return "Sudoku is valid."
        elsif !sudoku_is_valid
          return "Sudoku is invalid."
        elsif !sudoku_is_complete &&  sudoku_is_valid
          return "Sudoku is valid but incomplete."
        end

      else 
        return "Sudoku is invalid."
      end
  end


  def sudoku_numbers_valid(sudoku)
    sudoku.each do |line|
      if line.length != 9
        return false
      end
    end
    return true
  end



  def get_sudoku_grid_file(sudoku)
    grid = []
    grid_one = ""
    grid_two = ""
    grid_three = ""
    sudoku.each do |row|
      if grid_one.length == 9
        grid << grid_one
        grid << grid_two
        grid << grid_three
        grid_one = row[0..2]
        grid_two = row[3..5]
        grid_three = row[6..8]
      else 
        grid_one += row[0..2]
        grid_two += row[3..5]
        grid_three += row[6..8]
      end
    end 
    grid << grid_one
    grid << grid_two
    grid << grid_three
    return grid
  end 

  #gets columns from row file 
  def get_sudoku_columns(sudoku)
    column_array = []
     #loop over all individual row indexes
    for index in 0..8 
      column = ""
      #loop over every row and add the index to create column
      for row in 0..8
        column += sudoku[row][index]
      end 
      column_array << column
    end
    return column_array
  end
  
  #get the sudoku puzzle and remove "|" and spaces
  def get_sudoku_row_file(file)
    file_data = file.split("\n",11)
    file_data.delete_at(3)
    file_data.delete_at(6)
    new_file_data = file_data.map! { |line| line.gsub(/[| ]/,"").strip}

  end


  #check if the sudoku file contains at least one "0" then its not complete
  def is_sudoku_complete(sudoku)
    sudoku.each do |line|
      if line.count("0") > 0
        return false
      end
    end
    return true
  end


  #use function is_row_valid on all rows to see if the puzzles rows are valid
  def are_lines_valid(sudoku)
    for i in 0..8
      if !is_row_valid(sudoku[i])
        return false
      end
    end
    return true
  end

  #check an invididual row to see if it contains more than 1 of each number from 1-9
  def is_row_valid(row)
    for i in 1..9
      if row.count(i.to_s) > 1
        return false
      end
    end
    return true
  end
end
