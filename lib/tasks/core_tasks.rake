namespace :core do
  desc "Send a test email."
  task :test_email, [:to] => :environment  do |t, args|
    Core::TestMailer.test(args.to).deliver
    puts "A test mail was sent to #{args.to}."
  end
end


