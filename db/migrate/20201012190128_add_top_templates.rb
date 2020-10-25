class AddTopTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :top_templates do |t|
      t.string :background_image_svg, null: false

      t.timestamps
    end
  end
end
