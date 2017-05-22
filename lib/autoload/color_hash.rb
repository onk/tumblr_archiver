require "base64"
require "msgpack"
require "zlib"

module ColorHash
  def self.calc_hash(image)
    # 128x128 にリサイズ
    img = image.resize(256, 256)
    # rgb 6*6*6 の各色について、何ピクセル存在するかを集計する
    histogram = Array.new(216) { 0 }
    img.get_pixels(0, 0, img.columns, img.rows).each { |p|
      label = rgb2label(*rgb2safe_color(p.red, p.green, p.blue))
      histogram[label] += 1
    }
    # histogram を DB に保存できる文字列にする
    Base64.encode64(Zlib::Deflate.deflate(histogram.to_msgpack))
  end

  # 216 色 (web safe color) に減色
  # COLOR_TABLE = [0, 51, 102, 153, 204, 255]
  def self.rgb2safe_color(r, g, b)
    [r, g, b].map { |c|
      case c
      when     0..10922 then 0
      when 10923..21844 then 1
      when 21845..32767 then 2
      when 32768..43690 then 3
      when 43691..54612 then 4
      when 54613..65535 then 5
      end
    }
  end

  # [0, 0, 0] => 0
  # [5, 5, 5] => 215
  def self.rgb2label(r, g, b)
    r * (6 * 6) + g * 6 + b
  end
end
