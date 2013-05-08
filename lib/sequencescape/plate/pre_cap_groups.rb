module Sequencescape::Plate::PreCapGroups
  def populate_wells_with_pre_cap_group
    self.wells.each do |well|
      pre_cap_group_id, pre_cap_group = self.pre_cap_groups.detect { |_, pre_cap_group| pre_cap_group['wells'].include?(well.location) }
      next if pre_cap_group.nil?
      well.pre_cap_group = pre_cap_group
    end
  end

  def after_load
    self.pre_cap_groups.each { |pre_cap_group_id, pre_cap_group| pre_cap_group['id'] = pre_cap_group_id } unless self.pre_cap_groups.nil?
  end
  private :after_load
end
