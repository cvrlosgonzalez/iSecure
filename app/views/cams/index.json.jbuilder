json.array!(@cams) do |cam|
  json.extract! cam, :id, :title, :alert
  json.url cam_url(cam, format: :json)
end
