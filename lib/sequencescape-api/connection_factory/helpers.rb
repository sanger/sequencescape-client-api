module Sequencescape::Api::ConnectionFactory::Helpers
  def connection_factory=(connection_factory)
    @connection_factory = connection_factory
  end

  def connection_factory
    @connection_factory ||= Sequencescape::Api::ConnectionFactory
  end
end
