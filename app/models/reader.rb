class Reader < ApplicationRecord
  TURNAROUND_TIME_LABELS = {
    0 => 'Not specified',
    1 => 'Less than 1 week',
    2 => '1-2 weeks',
    3 => '2-3 weeks',
    4 => '3+ weeks'
  }.freeze

  def turnaround_time_label
    TURNAROUND_TIME_LABELS[turnaround_time] || 'Unknown'
  end
end