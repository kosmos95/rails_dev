class CreatePostContents < ActiveRecord::Migration[5.2]
  def change
    # create_table :post_contents, id: :integer, primary_key: [:post_id, :board_id], 
        # options: " PARTITION BY HASH(board_id) PARTITIONS 300" do |t|

      # #t.integer :id, null: false, auto_increment: true

      # t.belongs_to :post, index: true, type: :integer      
      # t.belongs_to :board, index: true, null: false, type: :integer
      # t.mediumtext :content

      # #t.string :files
      # t.string :source, limit: 191

    # end
  end
end
