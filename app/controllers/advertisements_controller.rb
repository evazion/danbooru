class AdvertisementsController < ApplicationController
  before_filter :advertiser_only

  def new
    @advertisement = Advertisement.new(
      :ad_type => "vertical",
      :status => "active"
    )
  end

  def edit
    @advertisement = Advertisement.find(params[:id])
  end

  def index
    @advertisements = Advertisement.order("id desc")
    @start_date = 1.month.ago.to_date
    @end_date = Date.today
  end

  def show
    @advertisement = Advertisement.find(params[:id])
  end

  def create
    @advertisement = Advertisement.new(permitted_params)
    if @advertisement.save
      redirect_to advertisement_path(@advertisement), :notice => "Advertisement created"
    else
      flash[:notice] = "There were errors"
      render :action => "new"
    end
  end

  def update
    @advertisement = Advertisement.find(params[:id])
    if @advertisement.update_attributes(permitted_params)
      redirect_to advertisement_path(@advertisement), :notice => "Advertisement updated"
    else
      flash[:notice] = "There were errors"
      render :action => "edit"
    end
  end

  def destroy
    @advertisement = Advertisement.find(params[:id])
    @advertisement.destroy
    redirect_to advertisements_path, :notice => "Advertisement destroyed"
  end

private
  def advertiser_only
    if !Danbooru.config.is_user_advertiser?(CurrentUser.user)
      raise User::PrivilegeError
      return false
    end
  end

  def permitted_params
    params.require(:advertisement).permit(:ad_type, :width, :height, :referral_url, :status, :file_name, :is_work_safe, :hit_count)
  end
end
