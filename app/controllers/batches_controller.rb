# frozen_string_literal: true

class BatchesController < ApplicationController
  before_action :set_batch, only: %i[show edit update destroy]

  def index
    authorize! :read, Batch

    @batches = Batch.accessible(current_user).includes(enrollments: :student)
                    .filtered(params[:school_id], params[:course_id], params[:batch_name])
                    .paginate(page: params[:page], per_page: 10)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_batch
    @batch = Batch.find(params[:id])
  end
end
