module Sequencescape::Plate::Pooling
  def populate_wells_with_pool
    wells.each do |well|
      pool_id, pool = pools.detect { |_, pool| pool['wells'].include?(well.location) }
      next if pool.nil?
      well.pool = pool
    end
  end

  def populate_wells_with_pre_cap_group
    wells.each do |well|
      pre_cap_group_id, pre_cap_group = pre_cap_groups.detect { |_, pre_cap_group| pre_cap_group['wells'].include?(well.location) }
      next if pre_cap_group.nil?
      well.pre_cap_group = pre_cap_group
    end
  end

  def after_load
    pools.each { |pool_id, pool| pool['id'] = pool_id } unless pools.nil?
    pre_cap_groups.each { |pre_cap_group_id, pre_cap_group| pre_cap_group['id'] = pre_cap_group_id } unless pre_cap_groups.nil?
  end
  private :after_load
end
