class CreateDataLayerFoundation < ActiveRecord::Migration[8.1]
  def change
    create_table :service_types, if_not_exists: true do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :duration_minutes, null: false, default: 60
      t.integer :capacity, default: 1
      t.text :description
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :service_types, :name, unique: true, if_not_exists: true
    add_index :service_types, :active, if_not_exists: true

    create_table :clients, if_not_exists: true do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.text :address
      t.text :notes
      t.string :timezone
      t.datetime :discarded_at
      t.timestamps
    end
    add_index :clients, :email, unique: true, if_not_exists: true

    create_table :dogs, if_not_exists: true do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false
      t.string :breed
      t.string :sex
      t.date :date_of_birth
      t.decimal :weight, precision: 5, scale: 2
      t.text :temperament
      t.text :medical_notes
      t.text :training_goals
      t.text :training_history
      t.datetime :discarded_at
      t.timestamps
    end

    create_table :appointments, if_not_exists: true do |t|
      t.references :client, null: false, foreign_key: true
      t.references :dog, foreign_key: true
      t.references :service_type, null: false, foreign_key: true
      t.string :series_id
      t.string :recurrence_rule
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :status, null: false, default: 0
      t.text :notes
      t.text :trainer_notes
      t.datetime :reminder_sent_at
      t.timestamps
    end
    add_index :appointments, :starts_at, if_not_exists: true
    add_index :appointments, :status, if_not_exists: true
    add_index :appointments, :series_id, if_not_exists: true

    create_table :enrollments, if_not_exists: true do |t|
      t.references :appointment, null: false, foreign_key: true
      t.references :dog, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :waitlist_position
      t.timestamps
    end
    add_index :enrollments, %i[appointment_id dog_id], unique: true, name: "index_enrollments_on_appointment_id_and_dog_id", if_not_exists: true
    add_index :enrollments, :status, if_not_exists: true

    create_table :invoices, if_not_exists: true do |t|
      t.references :client, null: false, foreign_key: true
      t.string :invoice_number, null: false
      t.date :issue_date, null: false
      t.date :due_date, null: false
      t.integer :status, null: false, default: 0
      t.decimal :subtotal, precision: 10, scale: 2, default: "0.0"
      t.decimal :tax, precision: 10, scale: 2, default: "0.0"
      t.decimal :total, precision: 10, scale: 2, default: "0.0"
      t.datetime :sent_at
      t.datetime :paid_at
      t.text :notes
      t.timestamps
    end
    add_index :invoices, :invoice_number, unique: true, if_not_exists: true
    add_index :invoices, :due_date, if_not_exists: true
    add_index :invoices, :status, if_not_exists: true

    create_table :invoice_line_items, if_not_exists: true do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :appointment, foreign_key: true
      t.string :description, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :total, precision: 10, scale: 2, null: false
      t.timestamps
    end
    add_index :invoice_line_items, :appointment_id, if_not_exists: true

    create_table :session_media, if_not_exists: true do |t|
      t.references :appointment, null: false, foreign_key: true
      t.references :dog, foreign_key: true
      t.string :media_type, null: false
      t.text :caption
      t.boolean :featured, default: false
      t.datetime :taken_at
      t.timestamps
    end
    add_index :session_media, :media_type, if_not_exists: true
    add_index :session_media, :featured, if_not_exists: true

    create_table :report_cards, if_not_exists: true do |t|
      t.references :appointment, foreign_key: true
      t.references :dog, null: false, foreign_key: true
      t.date :report_date, null: false
      t.integer :status, null: false, default: 0
      t.integer :overall_score
      t.integer :obedience_score
      t.integer :leash_manners_score
      t.integer :focus_score
      t.integer :socialization_score
      t.text :strengths
      t.text :areas_for_improvement
      t.text :homework
      t.text :trainer_notes
      t.string :share_token
      t.datetime :share_token_expires_at
      t.timestamps
    end
    add_index :report_cards, :report_date, if_not_exists: true
    add_index :report_cards, :share_token, unique: true, if_not_exists: true

    create_table :media_consents, if_not_exists: true do |t|
      t.references :client, null: false, foreign_key: true
      t.boolean :marketing_allowed, default: false, null: false
      t.boolean :social_media_allowed, default: false, null: false
      t.boolean :website_allowed, default: false, null: false
      t.boolean :internal_only, default: true, null: false
      t.text :notes
      t.datetime :consented_at
      t.timestamps
    end
    add_index :media_consents, :client_id, unique: true, if_not_exists: true

    create_table :marketing_contents, if_not_exists: true do |t|
      t.string :title, null: false
      t.text :body
      t.string :platform
      t.integer :status, null: false, default: 0
      t.datetime :scheduled_at
      t.datetime :published_at
      t.timestamps
    end
    add_index :marketing_contents, :platform, if_not_exists: true
    add_index :marketing_contents, :status, if_not_exists: true
    add_index :marketing_contents, :scheduled_at, if_not_exists: true

    create_table :marketing_content_media, if_not_exists: true do |t|
      t.references :marketing_content, null: false, foreign_key: true
      t.references :session_media, null: false, foreign_key: true
      t.timestamps
    end
    add_index :marketing_content_media, %i[marketing_content_id session_media_id], unique: true, name: "idx_marketing_content_media_unique", if_not_exists: true

    add_column :clients, :discarded_at, :datetime unless column_exists?(:clients, :discarded_at)
    add_index :clients, :discarded_at, if_not_exists: true
    add_column :dogs, :discarded_at, :datetime unless column_exists?(:dogs, :discarded_at)
    add_index :dogs, :discarded_at, if_not_exists: true
    add_column :report_cards, :status, :integer, default: 0, null: false unless column_exists?(:report_cards, :status)
  end
end
