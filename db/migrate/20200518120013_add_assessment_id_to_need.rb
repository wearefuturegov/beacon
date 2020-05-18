class AddAssessmentIdToNeed < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :needs, :assessment_id, :bigint
    add_foreign_key :needs,
                    :needs,
                    column: :assessment_id,
                    index: { algorithm: :concurrently },
                    validate: false
  end
end
