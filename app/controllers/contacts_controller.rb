class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash[:success] = 'Thank you for your message. We will contact you soon!'
      redirect_to contacts_path
    else
      flash[:danger] = 'Sorry something is wrong. The message was not sent. Please send an e-mail to taskssimply@gmail.com'
      render :new
    end
  end
end