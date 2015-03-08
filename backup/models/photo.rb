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
    }.sort_by{|a| -a[1]}.take(16)
  end
end
