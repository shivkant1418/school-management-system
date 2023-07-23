# frozen_string_literal: true

module Admin
  class BatchesController < Admin::AdminController
    before_action :set_batch, only: %i[show edit update destroy]

    def index
      authorize! :read, Batch

      @batches = Batch.accessible(current_user)
                      .filtered(params[:school_id], params[:course_id], params[:batch_name])
                      .paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.json { render json: { batches: @batches } }
      end
    end

    def show
      authorize! :read, @batch
    end

    def new
      authorize! :create, Batch

      @batch = Batch.new
    end

    def edit
      authorize! :update, @batch
    end

    def create
      @batch = Batch.new(course_params)

      authorize! :create, @batch if @batch.course

      if @batch.save
        redirect_to params[:redirect_page] == "course" ? admin_course_url(@batch.course) : admin_batches_url, notice: 'Batch was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @batch

      if @batch.update(course_params)
        redirect_to params[:redirect_page] == "course" ? admin_course_url(@batch.course) : admin_batches_url, notice: 'Batch was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! :destroy, @batch

      @batch.destroy

      redirect_to admin_batches_url, notice: 'Batch was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:batch).permit(:name, :description, :start_date, :end_date, :course_id)
    end
  end
end
