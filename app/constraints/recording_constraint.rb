class RecordingConstraint
  def initialize
    @recordings_enabled = ENV['RECORDING_ENABLED'] || true
  end

  def matches?(request)
    @recordings_enabled
  end
end
