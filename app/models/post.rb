# ## Schema Information
#
# Table name: `posts`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `integer`          | `not null, primary key`
# **`original_id`**  | `integer`          | `not null`
# **`url`**          | `string(255)`      | `not null`
# **`posted_at`**    | `datetime`         | `not null`
# **`photo_count`**  | `integer`          | `default("1"), not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
# ### Indexes
#
# * `original_id` (_unique_):
#     * **`original_id`**
# * `posted_at`:
#     * **`posted_at`**
# * `url`:
#     * **`url`**
#

class Post < ActiveRecord::Base
  has_many :photos
end
