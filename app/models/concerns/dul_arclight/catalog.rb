# frozen_string_literal: true

# Local extensions to:
# https://github.com/projectblacklight/arclight/blob/main/app/models/concerns/arclight/catalog.rb
#
module DulArclight
  ##
  # DUL-ArcLight specific methods for the Catalog Controller
  module Catalog
    extend ActiveSupport::Concern
    include Arclight::Catalog

    # DUL CUSTOMIZATION: send the source EAD XML file that we already have on the filesystem
    # Modeled after "raw" in BL core, see:
    # https://github.com/projectblacklight/blacklight/blob/main/app/controllers/concerns/blacklight/catalog.rb#L57-L63
    def ead_download
      original_id = params[:id]
      eadid = original_id.tr('-', '.')
      folder = Rails.root.join('finding-aid-data')
    
      Rails.logger.info "[DEBUG] eadid param: #{eadid}"
      Rails.logger.info "[DEBUG] folder: #{folder}"
    
      # Try exact match first
      exact_path = folder.join("#{eadid}.xml")
      Rails.logger.info "[DEBUG] Exact path: #{exact_path}"
      if File.exist?(exact_path)
        Rails.logger.info "[DEBUG] Found exact match, sending file"
        return send_file exact_path, filename: "#{eadid}.xml", type: 'application/xml'
      end
    
      # If not found, look inside files for matching <eadid>
      Rails.logger.info "[DEBUG] No exact match. Searching contents for <eadid> match..."
      fallback = Dir.glob(folder.join('*.xml')).find do |file|
        content = File.read(file)
        found = content.include?("<eadid") && content.include?(">#{eadid}</eadid>")
        Rails.logger.info "[DEBUG] Checked #{file}, match: #{found}"
        found
      end
    
      if fallback
        Rails.logger.info "[DEBUG] Found fallback file: #{fallback}"
        send_file fallback, filename: "#{eadid}.xml", type: 'application/xml'
      else
        Rails.logger.error "[ERROR] EAD file not found for ID: #{eadid}"
        render plain: "EAD file not found for ID: #{eadid}", status: 404
      end
    end

    private

    def ead_file_path
      "#{DulArclight.finding_aid_data}/ead/#{repo_id}/#{params[:id]}.xml"
    end

    def repo_id
      @document&.repository_config&.slug
    end
  end
end
