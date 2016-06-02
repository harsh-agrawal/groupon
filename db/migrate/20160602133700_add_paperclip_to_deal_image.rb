class AddPaperclipToDealImage < ActiveRecord::Migration
  def up
    add_attachment :deal_images, :image
    remove_column(:deal_images, :name, :string)
  end

  def down
    remove_attachment :deal_images, :image
    add_column(:deal_images, :name, :string)
  end
end
