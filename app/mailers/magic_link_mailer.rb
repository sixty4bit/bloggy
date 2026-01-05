class MagicLinkMailer < ApplicationMailer
  def code(magic_link)
    @magic_link = magic_link
    @identity = magic_link.identity

    mail(
      to: @identity.email_address,
      subject: "Your verification code is #{@magic_link.code}"
    )
  end
end
