# Class for infinity big numbers.
class BigNum
  attr_reader :sign, :value

  def initialize(sign, value = [])
    @sign = sign
    @value = value
  end

  def check_zero
    @value.each do |number|
      return false if number != 0
    end
    true
  end

  def change_sign
    if @sign.nil?
      @sign = '-'
      return self
    end
    @sign = nil if @sign == '-'
    self
  end

  def compare_with_another(number)
    @value.each.with_index do |num, index|
      return true if num > number.value[index]
      return false if num < number.value[index]
    end
    check_sign(number)
  end

  def equal(number)
    return false unless @sign == number.sign
    @value.each.with_index do |num, index|
      return false unless num == number.value[index]
    end
    true
  end

  def equal_without_sign(number)
    @value.each.with_index do |num, index|
      return false unless num == number.value[index]
    end
    true
  end

  def to_s
    s = sign.to_s
    value.each { |v| s += v.to_s }
    s
  end

  private

  def check_sign(number)
    return true if @sign.nil? && number.sign == '-'
    return false if number.sign.nil? && @sign == '-'
    nil
  end
end
