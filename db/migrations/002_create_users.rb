Sequel.migration do
  up do
    create_table? :users do
      primary_key :id
      String :username, unique: true, null: false
      String :password, null: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table? :users
  end
end