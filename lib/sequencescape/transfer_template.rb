require 'sequencescape-api/resource'

class Sequencescape::TransferTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name
  attribute_reader :transfers

  has_create_action :resource => 'transfer'
  has_create_action :preview!, :action => :preview, :resource => 'transfer'
end

class StampTemplate
  def initialize(api)
    @api = api
  end

  def find(uuid)
    self
  end

  def create!(attributes)
    #TODO ke4 remove the '_uuid endings'
    @api.plate_transfer.create!({
        :source_uuid => attributes[:source],
        :target_uuid => attributes[:destination],
        :transfer_map =>
          { "A1" => "A1", "B1" => "B1", "C1" => "C1", "D1" => "D1", "E1" => "E1", "F1" => "F1", "G1" => "G1", "H1" => "H1",
            "A2" => "A2", "B2" => "B2", "C2" => "C2", "D2" => "D2", "E2" => "E2", "F2" => "F2", "G2" => "G2", "H2" => "H2",
            "A3" => "A3", "B3" => "B3", "C3" => "C3", "D3" => "D3", "E3" => "E3", "F3" => "F3", "G3" => "G3", "H3" => "H3",
            "A4" => "A4", "B4" => "B4", "C4" => "C4", "D4" => "D4", "E4" => "E4", "F4" => "F4", "G4" => "G4", "H4" => "H4",
            "A5" => "A5", "B5" => "B5", "C5" => "C5", "D5" => "D5", "E5" => "E5", "F5" => "F5", "G5" => "G5", "H5" => "H5",
            "A6" => "A6", "B6" => "B6", "C6" => "C6", "D6" => "D6", "E6" => "E6", "F6" => "F6", "G6" => "G6", "H6" => "H6",
            "A7" => "A7", "B7" => "B7", "C7" => "C7", "D7" => "D7", "E7" => "E7", "F7" => "F7", "G7" => "G7", "H7" => "H7",
            "A8" => "A8", "B8" => "B8", "C8" => "C8", "D8" => "D8", "E8" => "E8", "F8" => "F8", "G8" => "G8", "H8" => "H8",
            "A9" => "A9", "B9" => "B9", "C9" => "C9", "D9" => "D9", "E9" => "E9", "F9" => "F9", "G9" => "G9", "H9" => "H9",
            "A10" => "A10", "B10" => "B10", "C10" => "C10", "D10" => "D10", "E10" => "E10", "F10" => "F10", "G10" => "G10", "H10" => "H10",
            "A11" => "A11", "B11" => "B11", "C11" => "C11", "D11" => "D11", "E11" => "E11", "F11" => "F11", "G11" => "G11", "H11" => "H11",
            "A12" => "A12", "B12" => "B12", "C12" => "C12", "D12" => "D12", "E12" => "E12", "F12" => "F12", "G12" => "G12", "H12" => "H12"
          }
      })
  end
end