# frozen_string_literal: true

module Api
  module V1
    module Student
      class BatchesController < BaseController
        before_action :authenticate_user!
        before_action :set_batch, only: %i[show edit update destroy]

        def index
          authorize! :read, Batch

          @batches = current_user.approved_batches.includes(enrollments: :student)
                                .filtered(params[:school_id], params[:course_id], params[:batch_name])
                                .paginate(page: params[:page], per_page: 10)

          pagination_json_response(@batches)
        end

        def show
          authorize! :read, @batch
          
          json_response(data: @batch)
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_batch
          @batch = Batch.find(params[:id])
        end
      end
    end
  end
end
