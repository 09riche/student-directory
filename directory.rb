@students = []
@name = ""
@cohort = ""
@notes = ""

# --------------loading and saving files ----------
def try_load_students
  puts `clear`
  filename = ARGV.first
  if filename.nil?
    load_students
  elsif File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

def load_students
  puts "Which file would you like to load?\n\n"
  puts Dir["./*.csv"]
  filename = gets.chomp
  file = File.open(filename, "r")
  file.readlines.each do |line|
    @name, @cohort, @notes = line.chomp.split(',')
    add_students_to_array
  end
  file.close
  puts "#{filename} has been loaded."
end

def save_students
  puts "Enter filename"
  filename = gets.chomp
  file = File.open(filename, "w")
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:notes]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
  puts "File saved to #{filename}."
end

#------------------ Menu and menu input processing -------
def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
    when "1"
      input_students
    when "2"
      show_students
    when "3"
      list_by_cohort
    when "4"
      append_notes
    when "5"
      delete_list
    when "6"
      delete_an_entry
    when "7"
      save_students
    when "8"
      load_students
    when "9"
      exit
    else
      puts "I don't know what you meant, try again."
  end
end

def input_students
  puts "Please enter the name of the student and their cohort. To finish, hit return twice."
  loop do
    puts "Name?"
    @name = STDIN.gets.chomp.capitalize
    break if @name.empty?
    puts "Cohort?"
    @cohort = STDIN.gets.chomp.capitalize
    add_students_to_array
    student_counter
  end
  @students
end

def add_students_to_array
  @students << {name: @name, cohort: @cohort, notes: @notes}
end

def delete_list
  @students = []
  puts "Working student list deleted."
end

def delete_an_entry
  puts "Which entry would you like to delete?\n"
  print_students_list
  delete = gets.chomp.to_i
  if !@students[delete]
    puts "No such entry"
  else
    @students.delete_at(delete - 1)
    puts "Entry deleted"
  end
end

def append_notes
  puts "Which entry would you like to append notes to?"
  print_students_list
  note_entry = (gets.chomp.to_i) - 1
  puts "Please write notes:"
  @notes = gets.chomp
  @students[note_entry][:notes] = @notes
end



# ---------- printing things ----------
def print_menu
  puts "\nMENU"
  puts "1. Input students"
  puts "2. List students"
  puts "3. List students by cohort"
  puts "4. Append notes to an entry"
  puts "5. Delete working list"
  puts "6. Delete an entry"
  puts "7. Save list to disk"
  puts "8. Load list from disk"
  puts "9. Exit"
end

def show_students
  print_header
  print_students_list
  student_counter
end

def list_by_cohort
  puts "Which cohort would you like to list by?"
  cohort = gets.chomp
  puts "Students in #{cohort} Cohort:\n\n"
  @students.each_with_index do |student, i|
    puts "#{i + 1}. #{student[:name]}" if student.key(cohort)
  end
end

def print_header
  puts `clear`
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_students_list
  @students.each_with_index do |student, i|
    puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} Cohort)\n\tNotes: #{student[:notes]}"
  end
end

def student_counter
  if @students.count == 1
    puts "\nWe have #{@students.count} villainous student.\n"
  else
    puts "\nWe have #{@students.count} villainous students.\n"
  end
end


interactive_menu
