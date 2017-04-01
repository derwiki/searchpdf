class CreateDocumentPages < ActiveRecord::Migration
  def change
    create_table :document_pages do |t|
      t.references :document, index: true, foreign_key: true
      t.integer :page_number
      t.text :text

      t.timestamps null: false
    end
  end
end
