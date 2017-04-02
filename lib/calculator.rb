require_relative 'io_module'
require_relative 'base_operation_mod'
require_relative 'multiplication_mod'
require_relative 'division_mod'
require_relative 'gcd_icm_mod'

def compare_two_numbers(first, second)
  return true if first.value.size > second.value.size
  return false if second.value.size > first.value.size
  first.compare_with_another(second)
end

def do_operation(line)
  case line[:sign]
  when ['+']
    BaseOperaion.sum(line[:first_number], line[:second_number])
  when ['-']
    BaseOperaion.substract(line[:first_number], line[:second_number])
  when ['*']
    Multiplication.multiplicate(line[:first_number], line[:second_number])
  else
    sub_do_operation(line)
  end
end

def sub_do_operation(line)
  case line[:sign]
  when ['/']
    Division.division(line[:first_number], line[:second_number])
  when ['gcd']
    GLmod.gcd(line[:first_number], line[:second_number])
  when ['lcm']
    GLmod.lcm(line[:first_number], line[:second_number])
  end
end

def process_calculate(line, file)
  result = do_operation(line)
  IOmod.write_data(file, result) unless line[:sign].nil?
end

def print_info
  puts 'This programm reads files, than check them for the correct data.'
  puts 'If it is all ok, its calculates numbers in file.'
  puts 'After all programm writes the result in open file and starts to work,'
  puts 'with another file.'
  puts 'If there are some trubles it writes about them in your command line.'
  puts '--------------------------------------------------------------------'
end

def calculator
  print_info
  ARGV.each do |file|
    unless (data = IOmod.read_data(file))
      puts 'File is empty.'
    end
    data = IOmod.check_for_correct(data)
    next if data.nil?
    data.each { |line| process_calculate(line, file) }
  end
end
