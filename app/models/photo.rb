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
# **`width`**             | `integer`          |
# **`height`**            | `integer`          |
# **`url`**               | `string(255)`      | `not null`
# **`image`**             | `string(255)`      |
# **`average_hash`**      | `string(255)`      |
# **`color_hash`**        | `string(1023)`     |
# **`has_downloaded`**    | `boolean`          | `default(FALSE), not null`
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
#

class Photo < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :post
  belongs_to :actor

  def suggest
    Photo.suggest(self.average_hash, self.id)
  end

  def suggest_by_color
    Photo.suggest_by_color(self.color_hash, self.id)
  end

  def save_with_actor(params)
    ActiveRecord::Base.transaction do
      if params[:actor]
        actor = Actor.find_or_create_by(name: params[:actor][:name])
        self.actor = actor
      else
        self.actor_id = nil
      end
      self.save!
    end
  end

  def self.suggest(average_hash, exclude_photo_ids = [])
    suggests = Photo.pluck(:id, :average_hash).select { |(id, _)| Array(exclude_photo_ids).exclude?(id) }.map { |(id, hash)|
      if average_hash && hash
        sum = (hash.to_i(16) | average_hash.to_i(16)).to_s(2).count("1")
        mul = (hash.to_i(16) & average_hash.to_i(16)).to_s(2).count("1")
        [id, mul.to_f / sum]
      else
        [id, 0]
      end
    }.sort_by { |a| -a[1] }.take(16)
    photo_ids = suggests.map { |(id, _)| id }
    photo_idx = Photo.find(photo_ids).index_by(&:id)
    suggests.map { |(id, rate)| [photo_idx[id], rate] }
  end

  def self.suggest_by_color(color_hash, exclude_photo_ids = [])
    suggests = Photo.pluck(:id, :color_hash).select { |(id, _)| Array(exclude_photo_ids).exclude?(id) }.map { |(id, hash)|
      if color_hash && hash
        self_hash   = deserialized_color_hash(color_hash)
        target_hash = deserialized_color_hash(hash)
        # 類似度を計算する
        sum = self_hash.sum
        min = 216.times.map { |i| [self_hash[i], target_hash[i]].min }.sum
        [id, min.to_f / sum]
      else
        [id, 0]
      end
    }.sort_by { |a| -a[1] }.take(16)
    photo_ids = suggests.map { |(id, _)| id }
    photo_idx = Photo.find(photo_ids).index_by(&:id)
    suggests.map { |(id, rate)| [photo_idx[id], rate] }
  end

  # msgpack を zlib したものを base 64 して保存してあるので逆算する
  def self.deserialized_color_hash(hash)
    MessagePack.unpack(Zlib::Inflate.inflate(Base64.decode64(hash)))
  end

  def deserialized_color_hash
    self.class.deserialized_color_hash(color_hash)
  end
end
