require_relative 'big_num'
require_relative 'division_mod'
require_relative 'base_operation_mod'
require_relative 'multiplication_mod'

#
module GLmod
  module_function

  def gcd(first, second)
    if compare_two_numbers(first, second)
      first = BaseOperaion.substract(first, second)
    else
      second = BaseOperaion.substract(second, first)
    end until compare_two_numbers(first, second).nil?
    first
  end

  def lcm(first, second)
    mult = Multiplication.multiplicate(first, second)
    divider = gcd(first, second)
    Division.division(mult, divider)
  end
end
