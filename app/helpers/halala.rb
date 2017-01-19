# coding: utf-8
# frozen_string_literal: true
class Halala
  CURRENCY= 'SAR'

  def initialize value
    halala= Integer(value)
    @riyal= Rational(halala, 100)
  end

  def to_s
    "#{riyal_string} #{CURRENCY}"
  end

private

  attr_reader :riyal

  def riyal_string
    if riyal < 0
      '(%.2f)' % riyal.abs
    else
      '%.2f' % riyal
    end
  end
end
