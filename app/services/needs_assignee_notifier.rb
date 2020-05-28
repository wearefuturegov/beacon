class NeedsAssigneeNotifier
  def self.notify_new_assignee(need)
    return unless need.saved_change_to_user_id? || need.saved_change_to_role_id? || need.send_email

    need_url = Rails.application.routes.url_helpers.need_url(need)

    send_need_email(need, need_url)
  end

  def self.bulk_notify_new_assignee(needs)
    changed_needs = needs.select { |need| need.saved_change_to_user_id? || need.saved_change_to_role_id? }
    return unless changed_needs.any?

    change_links = changed_needs.map { |need| "* #{Rails.application.routes.url_helpers.need_url(need)}" }.join("\n")
    need = changed_needs.first
    return unless need.send_email
    send_need_email(need, change_links)
  end

  def self.send_need_email(need, email_links)
    Rails.logger.debug("Sending email for need #{need.id}")
    if need.user_id?
      user = User.find(need.user_id)
      NeedAssigneeMailer.send_user_assigned_need_email(user.email, email_links).deliver
    elsif need.role_id?
      role_members = User.joins(:roles).where(roles: { id: need.role_id }).select(:email)
      role_members.each do |role_member|
        NeedAssigneeMailer.send_role_assigned_need_email(role_member.email, need.role.name, email_links).deliver
      end
    end
  end
end
