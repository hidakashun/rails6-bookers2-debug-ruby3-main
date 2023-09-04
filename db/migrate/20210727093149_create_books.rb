class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      #t.float :rate0.5の評価を行うために必要だと思ったがわからず断念
      t.timestamps
    end
  end
end
