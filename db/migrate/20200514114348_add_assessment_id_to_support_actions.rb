class AddAssessmentIdToSupportActions < ActiveRecord::Migration[6.0]
  def change
    add_column :needs, :assessment_id, :bigint
    add_foreign_key :needs,
                    :needs,
                    column: :assessment_id,
                    index: { algorithm: :concurrently },
                    validate: false
  end
end
