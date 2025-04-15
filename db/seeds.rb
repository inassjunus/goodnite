# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def initialize_users(limit)
  puts "Creating #{limit} new users"
  user_ids = []
  (1..limit).each do |n|
    email_prefix = SecureRandom.base64(3)
    params = {
      name: "user#{n}",
      email: "#{email_prefix}@email.com",
      password: "pass#{n}",
      password_confirmation: "pass#{n}"
    }
    new_user = User.create(params)
    if new_user.save
      user_ids << new_user.id
    end
  end
  user_ids
end

def initialize_clock_ins(user_ids, limit)
  puts "Creating #{limit} new clock ins for #{user_ids.count} users"
  user_ids.each do |user_id|
    (1..limit).each do |n|
      duration = rand(500)
      day = rand(0...7)
      clock_in_at = day.days.ago
      params = {
        user_id: user_id,
        clock_in_at: clock_in_at,
        clock_out_at: clock_in_at + duration.minutes,
        duration: duration
      }
      new_clock_in = ClockIn.create(params)
      new_clock_in.save
    end
  end
end

def initialize_followings(user_ids, limit)
  puts "Creating #{limit} new followings for #{user_ids.count} users"
  following_ids = user_ids.first(limit+1)
  user_ids.each do |user_id|
    following_ids.each do |following_id|
      if user_id == following_id
        next
      end

      params = {
        user_id: user_id,
        target_id: following_id
      }
      new_following = Following.create(params)
      new_following.save
    end
  end
end

user_limit = 20
if ENV["seed_user_limit"]&.to_i.present?
  user_limit = ENV["seed_user_limit"].to_i
end

user_ids = initialize_users(user_limit)

clock_in_limit = 20
if ENV["seed_clock_in_limit"]&.to_i.present?
  clock_in_limit = ENV["seed_clock_in_limit"].to_i
end
initialize_clock_ins(user_ids, clock_in_limit)

following_limit = 20
if ENV["seed_following_limit"]&.to_i.present?
  following_limit = ENV["seed_following_limit"].to_i
end
initialize_followings(user_ids, following_limit)
