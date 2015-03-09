# ## Schema Information
#
# Table name: `photos`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `integer`          | `not null, primary key`
# **`user_id`**           | `integer`          | `not null`
# **`original_post_id`**  | `integer`          | `not null`
# **`post_id`**           | `integer`          | `not null`
# **`actor_id`**          | `integer`          |
# **`width`**             | `integer`          | `not null`
# **`height`**            | `integer`          | `not null`
# **`url`**               | `string(255)`      | `not null`
# **`image`**             | `string(255)`      |
# **`average_hash`**      | `string(255)`      |
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
#
# ### Indexes
#
# * `post_id`:
#     * **`post_id`**
# * `user_id_and_actor_id`:
#     * **`user_id`**
#     * **`actor_id`**
# * `user_id_and_url`:
#     * **`user_id`**
#     * **`url`**
# * `width`:
#     * **`width`**
#

class Photo < ActiveRecord::Base
  belongs_to :post
  belongs_to :actor

  def filename
    "./archive/#{File.basename(url)}"
  end

  def suggest
    (Photo.all.to_a - [self]).map { |photo|
      if average_hash && photo.average_hash
        sum = (photo.average_hash.to_i(16) | self.average_hash.to_i(16)).to_s(2).chars.count("1")
        mul = (photo.average_hash.to_i(16) & self.average_hash.to_i(16)).to_s(2).chars.count("1")
        [photo, mul.to_f / sum]
      else
        [photo, 0]
      end
    }.sort_by { |a| -a[1] }.take(16)
  end
end
