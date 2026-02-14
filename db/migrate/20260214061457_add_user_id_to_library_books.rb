class AddUserIdToLibraryBooks < ActiveRecord::Migration[8.1]
  def change
    add_reference :library_books, :user, null: false, foreign_key: true
    add_index :library_books, [ :user_id, :dato_book_id ], unique: true
  end
end
