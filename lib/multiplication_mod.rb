require_relative 'big_num'
require_relative 'base_operation_mod'

#
module Multiplication
  module_function

  def multiplicate(first, second)
    return BigNum.new(nil, [0]) if first.check_zero || second.check_zero
    if compare_two_numbers(first, second)
      multiplicate_two_numbers(first, second)
    else
      multiplicate_two_numbers(second, first)
    end
  end

  def multiplicate_two_numbers(first, second)
    sign = '-' if second.sign == '-'
    sign = nil if second.sign == first.sign
    value = calculate_value(first.value.reverse, second.value.reverse)
    BigNum.new(sign, value.reverse)
  end

  def calculate_value(first, second)
    result = []
    second.each.with_index do |number, index|
      if index.zero?
        result = multiply_by_number(first, number, index)
        next
      else
        result = calc_new_number(first, number, index, result)
      end
    end
    remove_extra_zero(result)
  end

  def calc_new_number(first, number, index, result)
    new_number = multiply_by_number(first, number, index)
    BaseOperaion.sum(BigNum.new(nil, new_number.reverse),
                     BigNum.new(nil, result.reverse)).value.reverse
  end

  def multiply_by_number(number, coeff, index)
    residue = 0
    result = []
    (0..index).each { result << 0 }
    result += number.map do |numeral|
      new_number = numeral * coeff + residue
      residue = new_number / 10
      new_number % 10
    end
    residue != 0 ? (result << residue) : result
  end

  def remove_extra_zero(result)
    result.shift
    result
  end
end
