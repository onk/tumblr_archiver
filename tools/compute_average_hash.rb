# rails runner tools/compute_average_hash.rb
require "rmagick"
def calc_hash(photo)
  original = Magick::Image.read(photo.image.current_path)[0]

  # 16x16 にリサイズして二値化 (16bitなので半分の 2**15 を閾値に)
  img = original.resize(16, 16).threshold(32768)

  # 各ピクセルごとにビットを立てる
  # TODO: 二値化した後なので簡単に bit 取れそうなモンだが。。
  bits = []
  16.times do |y|
    16.times do |x|
      # 白黒なので red の値だけ見ればいい
      src = img.pixel_color(x, y)
      bits << (src.red == 0 ? 1 : 0)
    end
  end
  # bit -> 16進文字列 にして DB に詰める
  photo.average_hash = bits.join.to_i(2).to_s(16)
  photo.save!

  original.destroy!
  img.destroy!
rescue Magick::ImageMagickError
  # nop
end

def main
  i = 0
  Photo.find_each do |photo|
    p i if i % 100 == 0
    i += 1
    next if photo.average_hash?  # 計算済みならスキップ
    calc_hash(photo)
  end
end

main
