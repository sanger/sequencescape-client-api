require 'sequencescape-api'

module Sequencescape

end

require 'sequencescape/user'

require 'sequencescape/request'
require 'sequencescape/pipeline'
require 'sequencescape/batch'
require 'sequencescape/study'
require 'sequencescape/project'

require 'sequencescape/asset'
require 'sequencescape/barcoded_asset'
require 'sequencescape/asset_group'

require 'sequencescape/tube_purpose'
require 'sequencescape/library_tube'
require 'sequencescape/multiplexed_library_tube'
require 'sequencescape/sample_tube'
require 'sequencescape/sample'

require 'sequencescape/comment'
require 'sequencescape/plate'
require 'sequencescape/plate_purpose'
require 'sequencescape/well'

require 'sequencescape/qc_file'

require 'sequencescape/asset_audit'

require 'sequencescape/submission'
require 'sequencescape/submission_pool'
require 'sequencescape/order_template'
require 'sequencescape/order'

require 'sequencescape/search'

# Pulldown API support
require 'sequencescape/plate_creation'
require 'sequencescape/pooled_plate_creation'
require 'sequencescape/tube_creation'
require 'sequencescape/tube_from_tube_creation'
require 'sequencescape/specific_tube_creation'
require 'sequencescape/state_change'
require 'sequencescape/transfer_template'
require 'sequencescape/transfer'
require 'sequencescape/bulk_transfer'
require 'sequencescape/tag_layout_template'
require 'sequencescape/tag_group'
require 'sequencescape/volume_update'
require 'sequencescape/tag_layout'
require 'sequencescape/bait_library_layout'
require 'sequencescape/barcode_printer'

# TagQC support
require 'sequencescape/lot'
require 'sequencescape/robot'
require 'sequencescape/lot_type'
require 'sequencescape/qcable'
require 'sequencescape/stamp'
require 'sequencescape/template'
require 'sequencescape/tag2_layout_template'
require 'sequencescape/tag2_layout'
require 'sequencescape/plate_template'
require 'sequencescape/qcable_creator'
require 'sequencescape/qc_decision'
require 'sequencescape/plate_conversion'

# Events
require 'sequencescape/library_event'

# Ensure that the I18n stuff has been properly configured
I18n.config.load_path << File.expand_path(File.join(File.dirname(__FILE__), %w{sequencescape locale en.yml}))

