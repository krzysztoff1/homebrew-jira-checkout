# frozen_string_literal: true

# Class for interacting with git
class Git
  def self.checkout_to_branch(jira_key, jira_summary)
    branch_name = branch_name(jira_key, jira_summary)

    run_command("git checkout -b #{branch_name}")
  end

  private

  def run_command(command)
    `#{command}`
  end

  def branch_name(jira_key, jira_summary)
    "#{jira_key.downcase.gsub(/\s+/, '/')}-#{jira_summary.downcase.gsub(/\s+/, '-')}"
  end
end
