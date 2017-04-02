require_relative 'big_num'

# Module for sum and substraction
module BaseOperaion
  module_function

  # Calculate sum.
  def sum(first, second)
    return second if first.check_zero
    return first if second.check_zero
    return BigNum.new(nil, [0]) if first.equal(second)
    if compare_two_numbers(first, second)
      sum_two_numbers(first, second)
    else
      sum_two_numbers(second, first)
    end
  end

  # Deside, what need to do with numbers based on signs
  def sum_two_numbers(first, second)
    return substract(first, second.change_sign) unless first.sign == second.sign
    sign = first.sign
    value = calculate_sum(first.value.reverse, second.value.reverse)
    BigNum.new(sign, value)
  end

  # Calculates sum of two numbers.
  def calculate_sum(first, second)
    residue = 0
    result = []
    first.each.with_index do |number, index|
      sum = number + (index < second.size ? second[index] : 0) +
            residue
      residue = sum / 10
      result.push(sum % 10)
    end
    check_residue(residue, result).reverse
  end

  # Add to the result 1 more rank if it exist.
  def check_residue(residue, result)
    if residue != 0
      result << residue
    else
      result
    end
  end

  # Calculate substract.
  def substract(decremented, substracted)
    return decremented if substracted.check_zero
    return substracted.change_sign if decremented.check_zero
    if compare_two_numbers(decremented, substracted)
      substract_two_numbers(decremented, substracted)
    else
      substract_two_numbers(substracted, decremented).change_sign
    end
  end

  # Find how need to calculate numbers.
  def substract_two_numbers(decremented, substracted)
    result = check_exeptions(decremented, substracted)
    return result unless result.nil?
    sign = decremented.sign
    value = calc_value(decremented, substracted)
    BigNum.new(sign, remove_extra_zero(value).reverse)
  end

  # Check different situations.
  def check_exeptions(decremented, substracted)
    exeption = decremented.sign == substracted.sign && decremented.sign == '-'
    return sum(decremented, substracted) if exeption
    return sum(decremented, substracted.change_sign) if decremented.sign.nil? &&
                                                        substracted.sign == '-'
    nil
  end

  def calc_value(decremented, substracted)
    calculate_substract(decremented.value.reverse,
                        substracted.value.reverse)
  end

  # Calculates the substraction of two numbers.
  def calculate_substract(dec, substr)
    occupied = 0
    dec.map.with_index do |number, index|
      curr_num = number - (index < substr.size ? substr[index] : 0) - occupied
      occupied = curr_num < 0 ? 1 : 0
      occupied > 0 ? curr_num + 10 : curr_num
    end
  end

  # Removes extra zero in the beginning of the number
  def remove_extra_zero(result)
    result.pop if result.last.zero?
    result
  end
end
