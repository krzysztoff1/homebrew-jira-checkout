# frozen_string_literal: true

# Class for interacting with git
class Git
  def checkout_to_branch(jira_issue)
    branch_name = branch_name(jira_issue[:key], jira_issue[:summary])

    run_command("git checkout -b #{branch_name}")
  end

  private

  def run_command(command)
    `#{command}`
  end

  def branch_name(jira_key, jira_summary)
    "#{jira_key.downcase.gsub(/\s+/, '/')}/#{jira_summary.downcase.gsub(/[\[\]]/, '').gsub(/\s+/, '-')}"
  end
end
