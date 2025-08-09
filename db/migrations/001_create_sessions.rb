Sequel.migration do
  up do
    create_table? :sessions do
      primary_key :id
      String :session_token, null: false
      String :username, null: false
      DateTime :expires_at
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table? :sessions
  end
end