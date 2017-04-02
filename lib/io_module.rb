require 'csv'
require_relative 'big_num'

# Module for input and output
module IOmod
  module_function

  def write_data(file_name, result)
    CSV.open(file_name, 'a') do |row|
      row << ["Result = #{result}"]
    end
  end

  def read_data(file)
    unless File.exist?(file)
      puts "File #{file} does not exists, please create it."
      return
    end
    puts "Processing file #{file}"
    return nil if File.zero?(file)
    read_file(file)
  end

  def read_file(file_name)
    result = []
    CSV.foreach(file_name, headers: true) do |row|
      result.push(
        first_number: row['First number'],
        sign: row['Sign'],
        second_number: row['Second number']
      )
    end
    result
  end

  def change_line(line)
    first = []
    line[:first_number].each_char { |char| first << char }
    sign = line[:sign]
    second = []
    line[:second_number].each_char { |char| second << char }
    { first_number: first, sign: [sign], second_number: second }
  end

  def check_for_correct(data)
    data.map do |line|
      line = change_line(line)
      line[:first_number] = check_number(line[:first_number])
      line[:second_number] = check_number(line[:second_number])
      line[:sign] = check_operation(line[:sign])
      line
    end
  end

  def check_operation(char)
    return nil if char.first.nil?
    return nil if char.first.size > 3
    if char.first =~ %r{\+|-|\*|\/|(gcd)|(lcm)}
      char
    else
      puts 'File has incorrect operation with numbers.'
      return nil
    end
  end

  def check_number(number)
    sign = number.shift if number.first == '-'
    value = number.map do |num|
      begin
        Integer(num)
      rescue
        puts 'File has incorrect data.'
        exit
      end
    end
    BigNum.new(sign, value)
  end
end
