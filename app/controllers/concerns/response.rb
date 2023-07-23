module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def pagination_json_response(resources)
    json_response({ data: resources, meta: pagination_dict(resources) })
  end

  private

  def pagination_dict(resources)
    {
      current_page: resources.current_page,
      next_page: resources.next_page,
      prev_page: resources.previous_page,
      total_pages: resources.total_pages,
      total_count: resources.total_entries
    }
  end
end