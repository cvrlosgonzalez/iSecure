class AlertMailer < ActionMailer::Base

    def alert_created(user)
      mail(to: user.email,
          from:"services@gmail.com",
          subject:"Motion Detected",
          body: "An alaert has been created"
          )
    end

end
