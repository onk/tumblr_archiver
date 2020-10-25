# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `integer`          | `not null, primary key`
# **`name`**                | `string(255)`      | `not null`
# **`provider`**            | `string(255)`      | `not null`
# **`provider_user_id`**    | `string(255)`      | `not null`
# **`oauth_token`**         | `string(255)`      | `not null`
# **`oauth_token_secret`**  | `string(255)`      | `not null`
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
#
# ### Indexes
#
# * `provider_and_provider_user_id` (_unique_):
#     * **`provider`**
#     * **`provider_user_id`**
#

class User < ApplicationRecord
  def self.create_or_update_with_omniauth(auth)
    user = User.find_or_initialize_by(provider: auth["provider"], provider_user_id: auth["uid"])

    user.name               = auth["info"]["nickname"]
    user.oauth_token        = auth["credentials"]["token"]
    user.oauth_token_secret = auth["credentials"]["secret"]
    user.save!

    user
  end
end
