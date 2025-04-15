json.data do
  json.array! @followings, partial: "users/user", as: :user
end
