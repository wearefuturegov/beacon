class NeedsAssigneeNotifier

  def self.notify_new_assignee(need)
    return unless need.saved_change_to_user_id? || need.saved_change_to_role_id?

    if need.user_id?
      user = User.find(need.user_id)
      NeedAssigneeMailer.send_user_assigned_need_email(user.email, Rails.application.routes.url_helpers.need_url(need)).deliver
    elsif need.role_id?
      role_members = User.joins(:roles).where(roles: { id: need.role_id }).select(:email)
      role_members.each do |role_member|
        NeedAssigneeMailer.send_role_assigned_need_email(role_member.email, need.role.name, Rails.application.routes.url_helpers.need_url(need)).deliver
      end
    end
  end

  def self.bulk_notify_new_assignee(needs)
    changed_needs = needs.select { |need| need.saved_change_to_user_id?  || need.saved_change_to_role_id? }
    return unless changed_needs.any?

    change_links = changed_needs.map { |need| "* #{Rails.application.routes.url_helpers.need_url(need)}" }.join("\n")
    need = changed_needs.first
    if need.user_id?
      user = User.find(need.user_id)
      NeedAssigneeMailer.send_user_assigned_need_email(user.email, change_links).deliver
    elsif need.role_id?
      role_members = User.joins(:roles).where(roles: { id: need.role_id }).select(:email)
      role_members.each do |role_member|
        NeedAssigneeMailer.send_role_assigned_need_email(role_member.email, need.role.name, change_links).deliver
      end
    end
  end
end