class DropInsController < ApplicationController

  before_filter :authenticate_shopper!
  before_action :correct_drop_in_shopper, only: [:update, :destroy]

  def create
    retrieved_params = drop_in_params

    selected_date = retrieved_params.delete(:selected_date)
    selected_time = retrieved_params.delete(:selected_time)
    unless (selected_date.blank? || selected_time.blank?)
      time_value = "#{selected_date} #{selected_time} -0500"
      retrieved_params[:time] = time_value
    end

    @drop_in = DropIn.new(retrieved_params)

    if @drop_in.save 
      flash[:success] = "Your drop-in was scheduled! The retailer will be notified."
      redirect_to upcoming_drop_ins_path
    else
      recommendation = retrieve_recommendation_object
      if recommendation.is_a? Retailer
        @retailer = recommendation
        render 'retailers/show'
      elsif recommendation.is_a? Top
        @top = recommendation
        render 'tops/show'
      elsif recommendation.is_a? Bottom
        @bottom = recommendation
        render 'bottoms/show'
      elsif recommendation.is_a? Dress
        @dress = recommendation
        render 'dresses/show'
      else
        flash[:danger] = "There was an unexpected error scheduling your drop-in."
        redirect_to root_path
      end
    end
  end

  def update
    if @drop_in.update_attributes(drop_in_params)
      flash[:success] = "Your drop-in was updated! The retailer will be notified."
      redirect_to upcoming_drop_ins_path
    else
      flash[:danger] = "There was an unexpected error updating your drop-in."
      redirect_to root_path
    end
  end

  def destroy
    @drop_in.destroy
    flash[:success] = "Drop in cancelled. Retailer will be notified"
    redirect_to upcoming_drop_ins_path
  end

  def upcoming
    @drop_ins = DropIn.upcoming_for current_shopper.id
  end

  private
    def correct_drop_in_shopper
      @drop_in = DropIn.find(params[:id])
      redirect_to root_url unless (@drop_in.shopper == current_shopper)
    end

    def drop_in_params
      params.require(:drop_in).permit(:shopper_id, :retailer_id, :comment,
                          :selected_date, :selected_time,
                          drop_in_items_attributes: [:reservable_id, :reservable_type])
    end
end
