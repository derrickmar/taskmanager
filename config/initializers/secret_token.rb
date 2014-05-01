# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
TaskManager::Application.config.secret_key_base = '58250a113c85870e04a8564151ca0da8915eea57a6eb5cfc1a04ace05edd9037207d83e1ab36a52f16590bf55ecdfb265904f254b2872e1de73aaae20161dd44'
