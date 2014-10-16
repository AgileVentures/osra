FactoryGirl.define do

  provinces = [
      ['Damascus & Rif Dimashq', 11],
      ['Aleppo', 12],
      ['Homs', 13],
      ['Hama', 14],
      ['Latakia', 15],
      ['Deir Al-Zor', 16],
      ['Daraa', 17],
      ['Idlib', 18],
      ['Ar Raqqah', 19],
      ['Al Ḥasakah', 20],
      ['Tartous', 21],
      ['Al-Suwayada', 22],
      ['Al-Quneitera', 23],
      ['Outside Syria', 29]
  ]

  sequence :init_hash, (0..13).cycle do |n|
    { name: provinces[n][0], code: provinces[n][1] }
  end

  factory :province do
    initialize_with { Province.find_or_create_by(generate :init_hash) }
  end
end
