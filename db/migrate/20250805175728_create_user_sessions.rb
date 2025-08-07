class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.string :session_token
      t.string :ip_address

      t.timestamps
    end
  end
end
