# frozen_string_literal: true

# University Archives Record Groups, derived from collection ID
# (archdesc/did/unitid), provide a way to browse UA collections.
class UaRecordGroupsController < ApplicationController
  def index
    @record_groups = UA_RECORD_GROUPS
    @record_group_counts = record_group_counts
  end

  private

  def record_group_counts
    search_service = Blacklight.repository_class.new(blacklight_config)
    results = search_service.search(
      q: 'level_ssm:collection',
      'facet.field': 'ua_record_group_ssim',
      # Facet limit default is 100; -1 shows unlimited facet values.
      'f.ua_record_group_ssim.facet.limit': '-1',
      rows: 0
    )
    Hash[*results.facet_fields['ua_record_group_ssim']]
  end
end
