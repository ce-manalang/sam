class LibraryBook < ApplicationRecord
  belongs_to :user

  validates :dato_book_id, presence: true, uniqueness: { scope: :user_id, message: "already in library" }
end
