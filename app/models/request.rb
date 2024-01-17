
class Request < ApplicationRecord
  # Check if a request exists with a given request_id
  def self.exists_with_id?(request_id)
    exists?(request_id)
  end

  # Assign request to a user and set status
  def assign_to_user_and_set_status(user_id)
    update(user_id: user_id, status: 'assigned')
  end
end
