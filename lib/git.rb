# frozen_string_literal: true

# Class for interacting with git
class Git
  def checkout_to_branch(jira_issue)
    branch_name = branch_name(jira_issue[:key], jira_issue[:summary])

    output = run_command("git checkout -b #{branch_name} 2>&1")

    puts "\e[36mCreating branch '#{branch_name}'\e[0m"

    return unless output.include?('already exists')

    puts "Branch '#{branch_name}' already exists"
    run_command("git checkout #{branch_name}")
  end

  def pull
    puts "\e[36mPulling latest changes\e[0m"
    run_command('git pull')
  end

  private

  def run_command(command)
    `#{command}`
  end

  def branch_name(jira_key, jira_summary)
    "#{jira_key.downcase.gsub(/\s+/, '/')}/#{jira_summary.downcase.gsub(/[\[\]]/, '').gsub(/\s+/, '-')}"
  end
end
