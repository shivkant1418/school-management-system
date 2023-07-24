# frozen_string_literal: true

module Api
  module V1
    class BatchesController < BaseController
      def index
        authorize! :read, Batch

        @batches = Batch.accessible(current_user).includes(enrollments: :student)
                        .filtered(params[:school_id], params[:course_id], params[:batch_name])
                        .paginate(page: params[:page], per_page: 10)

        pagination_json_response(@batches)
      end
    end
  end
end
