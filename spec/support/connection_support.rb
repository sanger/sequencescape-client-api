module Sequencescape::ConnectionSupport
  def is_a_connection_handler
    duck_type(:success, :unauthenticated, :missing, :redirection)
  end
end
