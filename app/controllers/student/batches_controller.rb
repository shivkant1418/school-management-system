# frozen_string_literal: true

module Student
  class BatchesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_batch, only: %i[show edit update destroy]

    def index
      authorize! :read, Batch

      @batches = current_user.approved_batches.includes(enrollments: :student)
                             .filtered(params[:school_id], params[:course_id], params[:batch_name])
                             .paginate(page: params[:page], per_page: 10)
    end

    def show
      authorize! :read, @batch
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end
  end
end
