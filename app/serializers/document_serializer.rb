class DocumentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :document_type, :required, :antigen, :pcr, :validity, :data, :country_id
end
