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

class User < ActiveRecord::Base
end
