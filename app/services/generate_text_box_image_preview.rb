# frozen_string_literal: true

class GenerateTextBoxImagePreview
  def self.call(game)
    new.call(game)
  end

  def call(game)
    generator = TextImageGenerator.new(width: width, height: height)

    Tempfile.create(['box_image_preview', '.jpg']) do |tempfile|
      generator.render(game.title, tempfile.path)
      game.box_image.attach(io: tempfile, filename: filename(game), content_type: 'image/jpg')
    end
  end

  private

  def filename(game)
    "#{game.title}.jpg"
  end

  def width
    Game::BOX_IMAGE_DIMENSIONS[:width]
  end

  def height
    Game::BOX_IMAGE_DIMENSIONS[:height]
  end
end
