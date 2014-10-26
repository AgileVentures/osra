require 'rails_helper'

describe Status, type: :model do
  it 'should load the fixtures' do
    Status.all.each do |status|
      puts status.inspect
    end
  end

  it 'should retain the fixtures' do
    Status.all.each do |status|
      puts status.inspect
    end
  end
end
