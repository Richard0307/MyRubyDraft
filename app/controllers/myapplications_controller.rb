class MyapplicationsController < ApplicationController
  def index
    @myapplications = Myapplication.all
  end
  def new
    @myapplications = Myapplication.new
  end
  def create
    @myapplications = Myapplication.new(myapplication_params)
    if @myapplications.save
      redirect_to myapplications_path, notice: "Application was successfully created."
    else
      render :new
    end
  end
  def edit
    @myapplications = Myapplication.find(params[:id])
  end

  def update
    @myapplications = Myapplication.find(params[:id])
    if @myapplications.update(myapplication_params)
      redirect_to myapplications_path, notice: "Application was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @myapplications = Myapplication.find(params[:id])
    @myapplications.destroy
    redirect_to myapplications_path, notice: "Application was successfully deleted."
  end

  private

  def myapplication_params
    params.require(:myapplication).permit(:company, :role, :application_deadline, :status, :date_applied, :location, :job_description, :notes_for_interview_and_reflections)
  end



end
