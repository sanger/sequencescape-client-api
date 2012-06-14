module Sequencescape::Plate::Pooling
  def populate_wells_with_pool
    self.wells.each do |well|
      pool_id, pool = self.pools.detect { |_, pool| pool['wells'].include?(well.location) }
      next if pool.nil?
      well.pool = pool
    end
  end

  def after_load
    self.pools.each { |pool_id, pool| pool['id'] = pool_id } unless self.pools.nil?
  end
  private :after_load
end
