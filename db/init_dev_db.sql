-- Creating table for sessions
CREATE TABLE IF NOT EXISTS sessions (
    id SERIAL PRIMARY KEY,
    session_token VARCHAR NOT NULL,
    username VARCHAR NOT NULL,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating table for users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating table for products
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seeding products table
INSERT INTO products (name) VALUES
    ('Pizza - Pepperoni'),
    ('Pizza - Margherita'),
    ('Not Pizza - Hawaiian'),
    ('Pizza - Vegetarian'),
    ('Pizza - Bacon')
ON CONFLICT (name) DO NOTHING;

-- Seeding users table with hashed passwords
INSERT INTO users (username, password) VALUES
    ('admin', '0ddfef36e96474b1f31ac49a9cde9eb68cc07c978ac01545e76a5acc6590df5b'), 
    ('user', '8143e4d37076c5892453f262a3f349e2d273525b3fa096290f7db073e35e3472')
    ('test_user', '8ea750daae4409e958cd25b0eb45610d519f6b0eba8e979e8280a35f99b9a169')
ON CONFLICT (username) DO NOTHING;