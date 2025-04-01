#!/bin/bash

set -e  # Exit on any error

# Step1 : Create required Solr directories if not exist
SOLR_DATA_DIR="../solr/arclight/data"
if [ ! -d "$SOLR_DATA_DIR" ]; then
  echo "Creating Solr data directory..."
  mkdir -p "$SOLR_DATA_DIR"
fi

# Step2 : Set Solr permissions
echo "Setting the Solr directory permissions..."
sudo chown -R 8983:8983 "$SOLR_DATA_DIR"
sudo chmod -R 755 "$SOLR_DATA_DIR"

# Step 3: Build Docker containers without cache
echo "Building Docker containers..."
docker compose build --no-cache

# Step 4: Start containers in background
echo "Starting Docker containers"
docker compose up -d

# Wait for containers to fully boot
echo "Waiting for containers to become ready..."
sleep 10

# Step 5: Prepare db
echo "Preparing the Rails database"
docker compose exec app bundle exec rails db:schema:load
docker compose exec app bundle exec rails db:prepare
docker compose exec app bundle exec rails db:migrate

# Step 6: Index EAD XML files
echo "Indexing EAD files from /opt/app-root/finding-aid-data..."
docker compose exec app rake dul_arclight:index_dir DIR=/opt/app-root/finding-aid-data

echo "ArcLight setup and indexing is complete!"
