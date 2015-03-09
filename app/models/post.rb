# ## Schema Information
#
# Table name: `posts`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `integer`          | `not null, primary key`
# **`user_id`**      | `integer`          | `not null`
# **`original_id`**  | `integer`          | `not null`
# **`url`**          | `string(255)`      | `not null`
# **`posted_at`**    | `datetime`         | `not null`
# **`photo_count`**  | `integer`          | `default("1"), not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
# ### Indexes
#
# * `user_id_and_original_id` (_unique_):
#     * **`user_id`**
#     * **`original_id`**
# * `user_id_and_posted_at`:
#     * **`user_id`**
#     * **`posted_at`**
# * `user_id_and_url`:
#     * **`user_id`**
#     * **`url`**
#

class Post < ActiveRecord::Base
  has_many :photos
end
