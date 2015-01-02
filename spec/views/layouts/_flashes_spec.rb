require 'rails_helper'

RSpec.describe 'layouts/_flashes.html.erb', type: :view do
  context 'flash messages defined' do
    let(:flash_success) {flash[:success] = 'Success message!'}
    let(:flash_error) {flash[:error] = 'Error message!'}
    
    it 'should show flash messages' do
      flash_success and flash_error
      render
      expect(rendered).to have_selector '.flashes'
      expect(rendered).to match /Success message!/
      expect(rendered).to match /Error message!/
    end
  end

  context 'no flash messages defined' do
    it 'should not show flash messages' do
      render
      expect(rendered).to_not have_selector '.flashes'
    end
  end
end
