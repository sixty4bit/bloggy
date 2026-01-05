class Signups::CompletionsController < ApplicationController
  layout "public"

  def new
    redirect_to dashboard_path if Current.user.present?
  end

  def create
    account = Account.create_with_owner(
      name: completion_params[:account_name],
      owner_identity: Current.identity,
      owner_name: completion_params[:full_name]
    )

    Current.user = account.owner
    redirect_to dashboard_path, notice: "Welcome!"
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.join(", ")
    render :new, status: :unprocessable_entity
  end

  private

  def completion_params
    params.require(:signup).permit(:full_name, :account_name)
  end
end
