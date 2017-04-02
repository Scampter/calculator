require_relative 'big_num'
require_relative 'multiplication_mod'
require_relative 'base_operation_mod'

#
module Division
  module_function

  def division(divided, divisor)
    return nil if divisor.check_zero
    return divided if divisor.value.size == 1 && divisor.value[0] == 1
    result = checks(divided, divisor)
    return result unless result.nil?
    calculate_division(divided, divisor)
  end

  def checks(divided, divisor)
    return BigNum.new(nil, [0]) if divided.check_zero
    return BigNum.new(nil, [1]) if divided.equal(divisor)
    return BigNum.new('-', [1]) if divided.equal_without_sign(divisor)
    return BigNum.new(nil, [0]) unless compare_two_numbers(divided, divisor)
    nil
  end

  def calculate_division(divided, divisor)
    sign = '-' unless divided.sign == divisor.sign
    sign = nil if divided.sign == divisor.sign
    result = (1..divided.value.size).map { 0 }
    result += [1]
    value = big_loop(divided, divisor, result.reverse, [0])
    BigNum.new(sign, value)
  end

  def big_loop(divided, divisor, result, start)
    loop do
      coeff = count_coeff(result, start)
      if check_compare(divided, divisor, coeff)
        start = coeff
      else
        result = coeff
      end
      return good_result(result, divisor, divided) if check_end(result, start)
    end
  end

  def good_result(result, divisor, divided)
    mult = Multiplication.multiplicate(divisor, BigNum.new(nil, result))
    compare = compare_two_numbers(divided, mult)
    if compare
      result
    elsif compare.nil?
      result
    else
      change_result(result)
    end
  end

  def change_result(result)
    result.map.with_index do |num, index|
      index == result.size - 1 ? num - 1 : num
    end
  end

  def check_end(result, start)
    substr = BaseOperaion.substract(BigNum.new(nil, result),
                                    BigNum.new(nil, start)).value
    check_substr(substr)
  end

  def check_substr(substract)
    if substract.last == 1
      substract.pop
      substract.each { |num| return false if num != 0 }
      true
    else
      false
    end
  end

  def check_compare(divided, divisor, coeff)
    compare_two_numbers(divided,
                        Multiplication.multiplicate(divisor,
                                                    BigNum.new(nil, coeff)))
  end

  def count_coeff(result, start)
    sum = BaseOperaion.sum(BigNum.new(nil, result),
                           BigNum.new(nil, start)).value
    divide_by_2(sum)
  end

  def divide_by_2(number)
    calculate_div_by_2(0, number, [])
  end

  def calculate_div_by_2(residue, number, result)
    number.each.with_index do |num, index|
      if calc_new_num_div_2(num, residue).zero?
        result << 0 unless index.zero?
        residue = calc_new_num(num, residue) % 2
      elsif calc_new_num_div_2(num, residue) != 0
        result << calc_new_num_div_2(num, residue)
        residue = calc_new_num(num, residue) % 2
      end
    end
    result
  end

  def calc_new_num(num, residue)
    (num + residue * 10)
  end

  def calc_new_num_div_2(num, residue)
    calc_new_num(num, residue) / 2
  end
end
