Aws.config.update({
  credentials: Aws::Credentials.new(ENV['R2_ACCESS_KEY'], ENV['R2_SECRET_KEY']),
  region: 'auto',
})

R2_CLIENT = Aws::S3::Client.new(
  endpoint: "https://#{ENV['R2_ACCOUNT_ID']}.r2.cloudflarestorage.com",
  force_path_style: true
)