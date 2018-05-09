@students = []
@name = ""
@cohort = ""

# --------------loading and saving files ----------
def try_load_students
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
    @name, @cohort = line.chomp.split(',')
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
    student_data = [student[:name], student[:cohort]]
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
      save_students
    when "4"
      load_students
    when "5"
      list_by_cohort
    when "9"
      exit
    else
      puts "I don't know what you meant, try again"
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
  @students << {name: @name, cohort: @cohort.to_sym}
end

# ---------- printing things ----------
def print_menu
  puts "\nMENU"
  puts "1. Input the students"
  puts "2. List the students"
  puts "3. Save the list to disk"
  puts "4. Load the list from disk"
  puts "5. List the students by cohort"
  puts "9. Exit"
end

def show_students
  print_header
  print_students_list
  student_counter
end

def list_by_cohort
  puts "Which cohort would you like to list by?"
  cohort = gets.chomp.to_sym
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
    puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} Cohort)"
  end
end

def student_counter
  if @students.count == 1
    puts "\nWe have #{@students.count} villainous student.\n"
  else
    puts "\nWe have #{@students.count} villainous students.\n"
  end
end

try_load_students
interactive_menu
