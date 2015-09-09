class StyleProfilesController < ApplicationController

  before_filter :store_shopper_location
  before_filter :authenticate_shopper!
  before_action :correct_style_profile_shopper

  def edit
  end

  def update
    if @style_profile.update_attributes(style_profile_params)
      flash[:success] = "Your Style Profile has been updated!"
      redirect_to upcoming_drop_ins_path
    else
      flash[:danger] = "Whoops! Something went wrong. Please try again"
      render "edit"
    end
  end

  private
    
    def correct_style_profile_shopper
      @style_profile = StyleProfile.find(params[:id])
      redirect_to root_url unless (@style_profile.shopper == current_shopper)
    end

    def style_profile_params
      params.require(:style_profile).permit(:body_shape_id, :height_feet, :height_inches, :top_fit_id, :bottom_fit_id,
                                            :top_budget, :bottom_budget, :dress_budget,
                                            top_size_ids: [], bottom_size_ids: [], dress_size_ids: [], body_build_ids: [],
                                            budget_attributes: [:top_range_string, :bottom_range_string, :dress_range_string],
                                            look_tolerances_attributes: [:id, :look_id, :tolerance],
                                            print_tolerances_attributes: [:id, :print_id, :tolerance],
                                            part_exposure_tolerances_attributes: [:id, :part_id, :tolerance],
                                            avoided_color_ids: [], special_consideration_ids: [])
    end
end
