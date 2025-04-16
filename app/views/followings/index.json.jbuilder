json.data do
  json.array! @followings, partial: "users/user_public", as: :user
end
