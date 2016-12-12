# coding: utf-8
# frozen_string_literal: true
class Halalas
  def initialize value
    @value= Integer(value)
    @currency_symbol= ' SAR'
  end

  def to_s
    riyals_string + @currency_symbol
  end

private

  def riyals
    @value.to_r / 100
  end

  def riyals_string
    if riyals < 0
      ('(%.2f)' % riyals.abs)
    else
      ('%.2f' % riyals)
    end
  end
end
