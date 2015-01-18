require 'rails_helper'

RSpec.describe Admin::CountryHelper, type: :helper do
  specify '#en_ar_country returns "(English) Arabic"' do
    expect(helper.en_ar_country('TR')).to eq '(Turkey) تركيا'
  end
end
