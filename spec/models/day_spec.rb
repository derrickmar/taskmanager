# == Schema Information
#
# Table name: days
#
#  id         :integer          not null, primary key
#  day        :string(255)
#  date       :date
#  complete   :boolean
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Day do
  pending "add some examples to (or delete) #{__FILE__}"
end
