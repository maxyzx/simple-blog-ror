module RequestParams
  extend ActiveSupport::Concern

  def request_params
    params.require(:request).permit(
      :area,
      :gender,
      :date_of_birth,
      :display_name,
      :menu,
      :hair_concerns,
      images: []
    )
  end
end
