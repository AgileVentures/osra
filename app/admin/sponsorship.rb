ActiveAdmin.register Sponsorship do
  menu if: proc { false }
  actions :create
  belongs_to :sponsor

  member_action :inactivate, method: :put do
    @sponsorship = Sponsorship.find(params[:id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @sponsorship.inactivate params[:end_date]
    flash[:success] = 'Sponsorship link was successfully terminated'
    redirect_to admin_sponsor_path(@sponsor)
  end

  controller do
    def create
      @sponsor = Sponsor.find(params[:sponsor_id])
      warning= "Cannot understand Sponsorship Start Date: \"#{ params[:sponsorship_start_date] }\"" unless get_start_date
      warning||= create_sponsorship
      if warning
        flash[:warning]= warning
        redirect_to new_sponsorship_path(@sponsor, scope: 'eligible_for_sponsorship')
      else
        flash[:success] = 'Sponsorship link was successfully created'
        redirect_to admin_sponsor_path(@sponsor)
      end
    end

    def create_sponsorship
      begin
        @orphan = Orphan.find(params[:orphan_id])
        Sponsorship.create!(sponsor: @sponsor, orphan: @orphan, start_date: @start_date)
        false
      rescue
        'Unable to create sponsorship'
      end
    end

    def get_start_date
      begin
        if params[:sponsorship_start_date]
          @start_date= if params[:sponsorship_start_date].to_s== ''
            nil
          else
            Date.parse(params[:sponsorship_start_date].to_s)
          end
          true
        end
      rescue
        false
      end
    end

  end

  permit_params :orphan_id
end
