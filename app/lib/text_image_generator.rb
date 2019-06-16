# frozen_string_literal: true

class TextImageGenerator
  def initialize(width:, height:)
    @width  = width
    @height = height
  end

  def render(string, output_path)
    MiniMagick::Tool::Convert.new do |image|
      image.size       "#{width}x#{height}"
      image.background 'white'
      image.font       'fonts/Carter_One/CarterOne.ttf'
      image.gravity    'Center'
      image << "caption:#{string}"

      image << output_path
    end
  end

  private

  attr_reader :width, :height
end
