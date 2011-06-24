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
require 'sequencescape/asset_group'
require 'sequencescape/library_tube'
require 'sequencescape/sample_tube'
require 'sequencescape/sample'

require 'sequencescape/plate'
require 'sequencescape/plate_purpose'
require 'sequencescape/well'

require 'sequencescape/asset_audit'

require 'sequencescape/submission'
require 'sequencescape/submission_template'

require 'sequencescape/search'

# Pulldown API support
require 'sequencescape/plate_creation'
require 'sequencescape/state_change'
require 'sequencescape/transfer_template'
require 'sequencescape/transfer'
require 'sequencescape/tag_layout_template'
require 'sequencescape/tag_layout'
require 'sequencescape/bait_library_layout'
require 'sequencescape/barcode_printer'

# Ensure that the I18n stuff has been properly configured
I18n.config.load_path << File.expand_path(File.join(File.dirname(__FILE__), %w{sequencescape locale en.yml}))

