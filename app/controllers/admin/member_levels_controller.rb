class Admin::MemberLevelsController < AdminsController
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def index
    @member_levels = MemberLevel.page(params[:page]).per(10)
  end

  def new
    @member_level = MemberLevel.new
  end

  def create
    @member_level = MemberLevel.new(member_level_params)

    if @member_level.save
      flash[:notice] = 'Member level created successfully!'
      redirect_to member_levels_path
    else
      flash.now[:alert] = 'Member level creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @member_level.update(member_level_params)
      flash[:notice] = 'Member level updated successfully!'
      redirect_to member_levels_path
    else
      flash.now[:alert] = 'Member level update failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @member_level.destroy
      flash[:notice] = 'Member level deleted successfully!'
    else
      flash[:alert] = "Member level in use and can't be deleted"
    end
    redirect_to member_levels_path
  end

  private

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end

  def member_level_params
    params.require(:member_level).permit(:required_members, :coins)
  end
end