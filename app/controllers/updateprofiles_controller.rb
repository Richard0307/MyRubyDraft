class UpdateprofilesController < ApplicationController
  before_action :set_updateprofile, only: %i[ show edit update destroy ]

  # GET /updateprofiles
  def index
    @updateprofiles = Updateprofile.all
  end

  # GET /updateprofiles/1
  def show
  end

  # GET /updateprofiles/new
  def new
    @updateprofile = Updateprofile.new
  end

  # GET /updateprofiles/1/edit
  def edit
  end

  # POST /updateprofiles
  def create
    @updateprofile = Updateprofile.new(updateprofile_params)

    if @updateprofile.save
      redirect_to @updateprofile, notice: "Updateprofile was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /updateprofiles/1
  def update
    if @updateprofile.update(updateprofile_params)
      redirect_to @updateprofile, notice: "Updateprofile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /updateprofiles/1
  def destroy
    @updateprofile.destroy
    redirect_to updateprofiles_url, notice: "Updateprofile was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_updateprofile
      @updateprofile = Updateprofile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def updateprofile_params
      params.require(:updateprofile).permit(:first_name, :last_name, :email, :student_status, :reason_for_withdrawing, :location, :course, :sector)
    end
end
