class Photo < ActiveRecord::Base
  belongs_to :post

  def filename
    File.basename(url)
  end
end
