FactoryGirl.define do
  factory :province do
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
    sequence(:name, 0) { |n| provinces[n][0] }
    sequence(:code, 0) { |n| provinces[n][1] }
  end
end