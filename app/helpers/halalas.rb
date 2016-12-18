# coding: utf-8
# frozen_string_literal: true
class Halalas
  CURRENCY= ' SAR'

  def initialize value
    @halalas= Integer(value)
    @riyals= Rational(@halalas, 100)
  end

  def to_s
    riyals_string + CURRENCY
  end

private

  def riyals_string
    if @riyals < 0
      '(%.2f)' % @riyals.abs
    else
      '%.2f' % @riyals
    end
  end
end
