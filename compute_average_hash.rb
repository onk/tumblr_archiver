#!/usr/bin/env ruby
$LOAD_PATH.push File.expand_path(__dir__)
require "bundler/setup"
Bundler.require

def initialize_database
  path = File.join(__dir__, "config/database.yml")
  spec = YAML.load_file(path) || {}
  ActiveRecord::Base.configurations = spec.stringify_keys
  ActiveRecord::Base.establish_connection(:development)
end

def require_models
  Dir.glob("models/**/*.rb").each do |f|
    require f
  end
end

def calc_hash(photo)
  original = Magick::Image.read(photo.filename)[0]

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
  initialize_database
  require_models

  i = 0
  Photo.find_each do |photo|
    p i if i % 100 == 0
    i += 1
    next if photo.average_hash?  # 計算済みならスキップ
    calc_hash(photo)
  end
end

main
