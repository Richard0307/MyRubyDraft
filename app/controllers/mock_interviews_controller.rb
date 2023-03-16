class MockInterviewsController < ApplicationController
  before_action :set_mock_interview, only: %i[ show edit update destroy ]

  # GET /mock_interviews
  def index
    @mock_interviews = MockInterview.all
  end

  # GET /mock_interviews/1
  def show
  end

  # GET /mock_interviews/new
  def new
    @mock_interview = MockInterview.new
    @mock_interview.user = current_user
  end

  # GET /mock_interviews/1/edit
  def edit
  end

  # POST /mock_interviews
  def create
    @mock_interview = MockInterview.new(mock_interview_params)
    @mock_interview.user = current_user

    if @mock_interview.save
      redirect_to @mock_interview, notice: "Mock interview was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mock_interviews/1
  def update
    if @mock_interview.update(mock_interview_params)
      redirect_to @mock_interview, notice: "Mock interview was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /mock_interviews/1
  def destroy
    @mock_interview.destroy
    redirect_to mock_interviews_url, notice: "Mock interview was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_mock_interview
    @mock_interview = MockInterview.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def mock_interview_params
    params.require(:mock_interview).permit(:interviewer_name, :feedback, :user_id)
  end
end
