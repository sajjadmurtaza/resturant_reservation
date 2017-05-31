json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :user_id, :party_name, :number_of_people, :estimated_time, :party_time
  json.url reservation_url(reservation, format: :json)
end
