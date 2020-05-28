class AddSendEmailToNeeds < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :send_email, :boolean, default: false
  end
end
