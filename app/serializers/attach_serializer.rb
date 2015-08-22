class AttachSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    object.file.url
  end
end
