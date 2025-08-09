Sequel.migration do
  up do
    create_table? :products do
      primary_key :id
      String :name, unique: true, null: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table? :products
  end
end