class SetDefaultStatusOnNeeds < ActiveRecord::Migration[6.0]
  def change
    change_column_default :needs, :status, from: nil, to: 'to_do'
  end
end
