class Photo < ActiveRecord::Base
  belongs_to :post

  def filename
    "./archive/#{File.basename(url)}"
  end
end
