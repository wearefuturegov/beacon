class PrescriptionPickupsNeed < Need
  jsonb_accessor :data,
    has_free_prescriptions: :boolean,
    local_pharmacy: :string
end
