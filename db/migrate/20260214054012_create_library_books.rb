class CreateLibraryBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :library_books do |t|
      t.string :dato_book_id
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
