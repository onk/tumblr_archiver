module AverageHash
  def self.calc_hash(image)
    # 16x16 にリサイズして二値化 (16bitなので半分の 2**15 を閾値に)
    img = image.resize(16, 16).threshold(32768)
    # 各ピクセルごとにビットを立てる。白黒なので red の値だけ見ればいい
    bits = img.get_pixels(0, 0, img.columns, img.rows).map { |p| p.red == 0 ? 1 : 0 }
    # bit -> 16進文字列 にして DB に詰める
    bits.join.to_i(2).to_s(16)
  rescue Magick::ImageMagickError
    Rails.logger.error(e)
  end
end
