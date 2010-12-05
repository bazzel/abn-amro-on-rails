def upload_file(file)
  File.new(File.join(Rails.root, "spec/fixtures/upload", file))
end