module SummaryJobsHelper
  def comment_field(user)
    buffer = ActiveSupport::SafeBuffer.new
    content_tag(:td, user.comment_for_project,
                class: 'editable-field td-comment',
                name: "user[comment]", value: "comment", id: "#{user.id}") do
      buffer << user.comment_for_project
      buffer
    end
  end
end