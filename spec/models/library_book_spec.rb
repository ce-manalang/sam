require 'rails_helper'

RSpec.describe LibraryBook, type: :model do
  it 'is valid with valid attributes' do
    user = User.create!(email: 'test@example.com', password: 'password')
    book = LibraryBook.new(user: user, dato_book_id: '123')
    expect(book).to be_valid
  end

  it 'is invalid without a dato_book_id' do
    user = User.create!(email: 'test@example.com', password: 'password')
    book = LibraryBook.new(user: user, dato_book_id: nil)
    expect(book).not_to be_valid
  end

  it 'belongs to a user' do
    user = User.create!(email: 'test@example.com', password: 'password')
    book = LibraryBook.new(user: user, dato_book_id: '123')
    expect(book.user).to eq(user)
  end

  describe 'uniqueness' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password') }
    let!(:existing) { LibraryBook.create!(user: user, dato_book_id: '123') }

    it 'prevents duplicate dato_book_id for the same user' do
      duplicate = LibraryBook.new(user: user, dato_book_id: '123')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:dato_book_id]).to include('already in library')
    end

    it 'allows same dato_book_id for different users' do
      other_user = User.create!(email: 'other@example.com', password: 'password')
      other_book = LibraryBook.new(user: other_user, dato_book_id: '123')
      expect(other_book).to be_valid
    end
  end
end
