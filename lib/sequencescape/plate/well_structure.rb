module Sequencescape::Plate::WellStructure
  def rows
    case size
    when 96  then ('A'..'H')
    when 384 then ('A'..'P')
    else          raise RuntimeError, "Unknown plate size #{size}"
    end
  end

  def columns
    case size
    when 96  then (1..12)
    when 384 then (1..24)
    else          raise RuntimeError, "Unknown plate size #{size}"
    end
  end

  def locations_in_rows
    [].tap do |locations|
      rows.each do |row|
        columns.each do |column|
          locations << "#{row}#{column}"
        end
      end
    end
  end
end
