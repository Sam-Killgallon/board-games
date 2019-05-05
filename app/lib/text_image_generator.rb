# frozen_string_literal: true

class TextImageGenerator
  def initialize(width:, height:)
    @width  = width
    @height = height
  end

  def render(string, output_path)
    MiniMagick::Tool::Convert.new do |i|
      i.size       '450x300'
      i.background 'white'
      i.font       'fonts/Carter_One/CarterOne.ttf'
      i.gravity    'Center'
      i << "caption:#{string}"

      i << output_path
    end
  end
end
