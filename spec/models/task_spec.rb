# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  description :string(255)
#  important   :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  day_id      :integer
#  complete    :boolean
#  ordering    :integer          default(0)
#  user_id     :integer
#  due_at      :datetime
#  overdue     :boolean
#  email       :boolean
#

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
